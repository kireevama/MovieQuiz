//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Marina Kireeva on 13.07.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?) //метод, который должен быть у делегата фабрики — его будет вызывать фабрика, чтобы отдать готовый вопрос квиза
}
