//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Marina Kireeva on 11.08.2024.
//

import Foundation

final class StatisticService {
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correct, bestGame, gamesCount, total, date, totalAccuracy, totalCorrect
    }
}

extension StatisticService: StatisticServiceProtocol {    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var correct: Int {
        get {
            storage.integer(forKey: Keys.correct.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var total: Int {
        get {
            storage.integer(forKey: Keys.total.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var totalCorrect: Int {
        get {
            storage.integer(forKey: Keys.totalCorrect.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrect.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            storage.double(forKey: Keys.totalAccuracy.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalAccuracy.rawValue)
        }
        
    }
    
    var bestGame: GameResult {
        get {
            GameResult(correct: storage.integer(forKey: Keys.correct.rawValue),
                       total: storage.integer(forKey: Keys.total.rawValue),
                       date: storage.object(forKey: Keys.date.rawValue) as? Date ?? Date())
        }
        set {
            storage.set(newValue.correct, forKey: Keys.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.total.rawValue)
            storage.set(newValue.date, forKey: Keys.date.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        let correct = count
        self.totalCorrect += correct
        
        totalAccuracy = (Double(totalCorrect) / Double(total * gamesCount)) * 100
        
        let newBestGame = GameResult(correct: correct, total: amount, date: Date())

            if newBestGame.isBetterThan(bestGame) {
//                bestGame = GameResult(correct: correct, total: amount, date: Date())
                bestGame = newBestGame
            }
           
    }
    
}
