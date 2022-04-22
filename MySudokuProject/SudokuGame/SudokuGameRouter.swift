//
//  SudokuGameRouter.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 07.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SudokuGameRoutingLogic {
    func displayGameOver()
    func displayPause()
}

class SudokuGameRouter: NSObject, SudokuGameRoutingLogic {

  weak var viewController: SudokuGameViewController?
  
  // MARK: Routing
    
    func displayGameOver() {
        let vc = StartGameViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.interactor?.makeRequest(request: StartGame.Model.Request.RequestType.checkSavedGame)
        vc.interactor?.makeRequest(request: StartGame.Model.Request.RequestType.gameOver)
        viewController?.present(vc, animated: true)
    }
    
    func displayPause() {
        let vc = StartGameViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.interactor?.makeRequest(request: StartGame.Model.Request.RequestType.checkSavedGame)
        vc.interactor?.makeRequest(request: StartGame.Model.Request.RequestType.pause)
        viewController?.present(vc, animated: true)
    }
}
