//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Marina Kireeva on 17.09.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    let questionAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var correctAnswers = 0
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    private var alertPresenter: AlertPresenterProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    init(viewController: MovieQuizViewController) {
            self.viewController = viewController
            
            questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
            questionFactory?.loadData()
            viewController.showLoadingIndicator()
        }
    
    // MARK: - QuestionFactoryDelegate
    
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
    
    func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = true
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = false
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
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
    
    func showNextQuestionOrResult () {
        if self.isLastQuestion() {
            viewController?.showResultsAlert()
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
        
        viewController?.noButton.isEnabled = true
        viewController?.yesButton.isEnabled = true
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer { correctAnswers += 1 }
    }

}
