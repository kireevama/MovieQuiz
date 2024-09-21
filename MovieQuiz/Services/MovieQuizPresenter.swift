//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Marina Kireeva on 17.09.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - Properties
    let questionAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var correctAnswers = 0
    
    private var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewControllerProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private let statisticService: StatisticServiceProtocol!
    
    // MARK: - QuestionFactoryDelegate
    private var questionFactory: QuestionFactoryProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - Methods
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let result = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: ("\(currentQuestionIndex + 1)/\(questionAmount)")
        )
        return result
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
        viewController?.buttonsAccessibility(isAvailable: false)
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
        viewController?.buttonsAccessibility(isAvailable: false)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = self.convert(model: question)
        DispatchQueue.main.async {
            self.viewController?.show(quiz: viewModel)
        }
    }
    
    private func proceedToNextQuestionOrResults() {
        viewController?.showLoadingIndicator()
        
        if self.isLastQuestion() {
            viewController?.hideLoadingIndicator()
            viewController?.showResultsAlert()
        } else {
            self.switchToNextQuestion()
            viewController?.hideLoadingIndicator()
            questionFactory?.requestNextQuestion()
        }
        
        viewController?.buttonsAccessibility(isAvailable: true)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func makeResultsMessage() -> String {
        guard let statisticService = statisticService else {
            assertionFailure("Error")
            return ""
        }
        
        guard let bestGame = self.statisticService?.bestGame else {
            assertionFailure("Error get bestGame")
            return ""
        }
        
        statisticService.store(correct: correctAnswers, total: questionAmount)
        
        let totalAccuracy = "\(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let massage = """
        Ваш результат: \(correctAnswers)/\(questionAmount)
        Количество сыгранных квизов: \(String(statisticService.gamesCount))
        Рекорд: \(String(bestGame.correct))/\(String(bestGame.total)) \(String(bestGame.date.dateTimeString))
        Средняя точность: \(totalAccuracy)
        """
        
        return massage
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        if isCorrect { correctAnswers += 1}
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
}

