//
//  MoviesLoadingProtocol.swift
//  MovieQuiz
//
//  Created by Marina Kireeva on 04.09.2024.
//

import Foundation

protocol MoviesLoadingProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
