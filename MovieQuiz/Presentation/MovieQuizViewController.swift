import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    // MARK: - Private properties
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
    let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }
    
    // MARK: - Private structs
    private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    private struct QuizResultViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    private struct QuizQuestion {
        let name: String
        let text: String
        let correctAnswer: Bool
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(name: "The Godfather",
                        text: "Рейтинг этого фильма больше чем 6?",
                        correctAnswer: true),
        QuizQuestion(name: "The Dark Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(name: "Kill Bill",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(name: "The Avengers",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(name: "Deadpool",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(name: "The Green Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(name: "Old",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(name: "The Ice Age Adventures of Buck Wild",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(name: "Tesla",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(name: "Vivarium",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false)
    ]

    // MARK: - Private methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let result = QuizStepViewModel(
            image: UIImage(named: model.name) ?? UIImage(),
            question: model.text,
            questionNumber: ("\(currentQuestionIndex+1)/\(questions.count)")
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
        if currentQuestionIndex == questions.count - 1 {
            quizeResultsAlert()
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
            
            noButton.isEnabled = true
            yesButton.isEnabled = true
        }
    }
    
    private func quizeResultsAlert() {
        let alert = UIAlertController(title: "Этот райнд окончен!", message: "Ваш результат \(correctAnswers)/\(questions.count)", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Сыграть еще раз", style: .default) {_ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
            
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - IBAction
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex].correctAnswer
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion)
    }

    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex].correctAnswer
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion)
    }
    
}
