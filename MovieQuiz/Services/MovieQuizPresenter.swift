//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Marina Kireeva on 17.09.2024.
//

import UIKit

final class MovieQuizPresenter {
    let questionAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    func isLastQuestion() -> Bool {
            currentQuestionIndex == questionAmount - 1
        }
        
        func resetQuestionIndex() {
            currentQuestionIndex = 0
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
}
