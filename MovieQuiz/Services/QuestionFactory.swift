//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Marina Kireeva on 03.07.2024.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoadingProtocol
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoadingProtocol, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageUrl)
            } catch {
                DispatchQueue.main.async { [weak self] in // new
                    self?.delegate?.didFailToLoadData(with: error) // new
                    return
                }
            }
            
            let rating = Float(movie.rating) ?? 0
            let questionRating = Float.random(in: 7...9)
            
            func getQuestion(message: String, operator: (_ rating: Float, _ questionRating: Float) -> Bool) {
                let questionRating = Int(questionRating)
    
                let text = "Рейтинг этого фильма \(message) чем \(questionRating)?"
                let correctAnswer = rating < Float(questionRating)

                let question = QuizQuestion(image: imageData,
                                            text: text,
                                            correctAnswer: correctAnswer)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didReceiveNextQuestion(question: question)
                }
            }
            if rating > 8.3 {
                    getQuestion(message: "больше") { $0 > $1 }
                } else {
                    getQuestion(message: "меньше") { $0 < $1 }
                }
                
            }
        }
    }
    
