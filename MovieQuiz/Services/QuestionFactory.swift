//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Marina Kireeva on 03.07.2024.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
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
    
    private weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
    }
    
    func requestNextQuestion () {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
    
}
