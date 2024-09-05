import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private properties
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionAmount = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory = questionFactory
        
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticService()
        
        showLoadingIndicator()
        questionFactory.loadData()
    }
    
    // MARK: - showLoadingIndicator
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    // MARK: - QuestionFactoryDelegate
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async {
            self.show(quiz: viewModel)
        }
    }
    
    // MARK: - Private methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let result = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: ("\(currentQuestionIndex + 1)/\(questionAmount)")
        )
        return result
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        imageView.layer.borderWidth = 0.0
        imageView.layer.cornerRadius = 20
        
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8.0
        
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResult()
        }
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
    }
    
    private func showNextQuestionOrResult () {
        if currentQuestionIndex == questionAmount - 1 {
            showResultsAlert()
        } else {
            currentQuestionIndex += 1

            questionFactory?.requestNextQuestion()
        }
        
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    func showResultsAlert () {
        statisticService?.store(correct: correctAnswers, total: questionAmount)
        
        let alertModel = AlertModel(title: "Этот раунд окончен!",
                                    message: makeResultMassage(),
                                    buttonText: "Сыграть еще раз",
                                    completion: { [weak self] in
            self?.currentQuestionIndex = 0
            self?.correctAnswers = 0
            self?.questionFactory?.requestNextQuestion()
            
        })
        
        alertPresenter?.show(resultsAlert: alertModel)
    }
    
    func showNetworkError (message: String) {
        hideLoadingIndicator()
        
        let alertModel = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать ещё раз") { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.show(resultsAlert: alertModel)
    }
    
    private func makeResultMassage () -> String {
        guard let statisticService = statisticService else {
            assertionFailure("Error")
            return ""
        }
        
        guard let bestGame = self.statisticService?.bestGame else {
            assertionFailure("Error get bestGame")
            return ""
        }
        
        let totalAccuracy = "\(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let massage = """
        Ваш результат: \(correctAnswers)/\(questionAmount)
        Количество сыгранных квизов: \(String(statisticService.gamesCount))
        Рекорд: \(String(bestGame.correct))/\(String(bestGame.total)) \(String(bestGame.date.dateTimeString))
        Средняя точность: \(totalAccuracy)
        """
        
        return massage
    }
    
    // MARK: - IBAction
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
}

