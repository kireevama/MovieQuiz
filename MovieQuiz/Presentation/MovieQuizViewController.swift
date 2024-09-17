import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private properties
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    private var presenter: MovieQuizPresenter!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticService()
        
        showLoadingIndicator()
//        questionFactory.loadData()
    }
    
    // MARK: - showLoadingIndicator
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
//    func didLoadDataFromServer() {
//        hideLoadingIndicator()
//        questionFactory?.requestNextQuestion()
//    }
    
//    func didFailToLoadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription)
//    }
    
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        presenter.didReceiveNextQuestion(question: question)
//    }
    
    // MARK: - Private methods    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        imageView.layer.borderWidth = 0.0
        imageView.layer.cornerRadius = 20
    }
    
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8.0
        
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.presenter.showNextQuestionOrResult()
        }
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
     
    func showResultsAlert () {
        statisticService?.store(correct: presenter.correctAnswers, total: presenter.questionAmount)
        
        let alertModel = AlertModel(title: "Этот раунд окончен!",
                                    message: makeResultMassage(),
                                    buttonText: "Сыграть еще раз",
                                    completion: { [weak self] in
            self?.presenter.restartGame()
            
        })
        
        alertPresenter?.show(resultsAlert: alertModel)
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать ещё раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
        alertPresenter?.show(resultsAlert: alertModel)
    }
    
    func makeResultMassage() -> String {
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
        Ваш результат: \(presenter.correctAnswers)/\(presenter.questionAmount)
        Количество сыгранных квизов: \(String(statisticService.gamesCount))
        Рекорд: \(String(bestGame.correct))/\(String(bestGame.total)) \(String(bestGame.date.dateTimeString))
        Средняя точность: \(totalAccuracy)
        """
        
        return massage
    }
    
    // MARK: - IBAction
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
}

