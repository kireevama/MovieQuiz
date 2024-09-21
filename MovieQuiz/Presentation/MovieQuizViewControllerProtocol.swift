//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Marina Kireeva on 21.09.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
        func showResultsAlert()
        
        func highlightImageBorder(isCorrectAnswer: Bool)
        
        func showLoadingIndicator()
        func hideLoadingIndicator()
    
        func buttonsAccessibility(isAvailable: Bool)
        
        func showNetworkError(message: String)
}
