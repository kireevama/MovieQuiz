//
//  NetworkRoutingProtocol.swift
//  MovieQuiz
//
//  Created by Marina Kireeva on 19.09.2024.
//

import Foundation

protocol NetworkRoutingProtocol {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
