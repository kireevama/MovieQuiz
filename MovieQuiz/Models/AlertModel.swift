//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Marina Kireeva on 30.07.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    
    let completion: (() -> Void)
}
