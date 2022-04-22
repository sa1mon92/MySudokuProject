//
//  StartGameRouter.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 21.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol StartGameRoutingLogic {
    func displaySavedGame()
    func displayNewGame(difficult: SudokuGameDifficult)
}

class StartGameRouter: NSObject, StartGameRoutingLogic {
    
    weak var viewController: StartGameViewController?
    
    // MARK: Routing
    
    func displaySavedGame() {
        let vc = SudokuGameViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.interactor?.makeRequest(request: SudokuGame.Model.Request.RequestType.startSavedGame)
        viewController?.present(vc, animated: true)
    }
    
    func displayNewGame(difficult: SudokuGameDifficult) {
        let vc = SudokuGameViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.interactor?.makeRequest(request: SudokuGame.Model.Request.RequestType.startNewGame(withDifficult: difficult))
        viewController?.present(vc, animated: true)
    }
}
