//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Marina Kireeva on 11.08.2024.
//

import Foundation

struct GameResult {
    var correct: Int // количество правильных ответов
    var total: Int // количество вопросов квиза
    var date: Date // дата
    
    func isBetterThan (_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
