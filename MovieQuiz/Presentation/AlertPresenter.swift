//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Marina Kireeva on 30.07.2024.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController? = nil) {
        self.delegate = delegate
    }

    func show(resultsAlert: AlertModel) {
        let alert = UIAlertController(
            title: resultsAlert.title,
            message: resultsAlert.message,
            preferredStyle:.alert)
        
        alert.view.accessibilityIdentifier = "Game results"
        
        let action = UIAlertAction(title: resultsAlert.buttonText, style: .default) { _ in
            
            resultsAlert.completion()
        }
        
        alert.addAction(action)
        delegate?.present(alert, animated: true)
    }
}

