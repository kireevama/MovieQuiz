//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Marina Kireeva on 11.08.2024.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
