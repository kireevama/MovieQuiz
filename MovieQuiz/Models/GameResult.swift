//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Marina Kireeva on 11.08.2024.
//

import Foundation

struct GameResult {
    var correct: Int
    var total: Int
    var date: Date
    
    func isBetterThan (_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
