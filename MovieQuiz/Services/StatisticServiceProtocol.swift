//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Marina Kireeva on 11.08.2024.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get } // кол-во сыгранных квизов
    var bestGame: GameResult { get } // лучший результат, дата/время
    var totalAccuracy: Double { get } // средняя точность
    
    func store(correct count: Int, total amount: Int) // метод для сохранения данных текущей игры
}
