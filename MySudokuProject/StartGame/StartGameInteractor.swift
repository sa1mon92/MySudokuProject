//
//  StartGameInteractor.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 21.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol StartGameBusinessLogic {
    func makeRequest(request: StartGame.Model.Request.RequestType)
}

class StartGameInteractor: StartGameBusinessLogic {
    
    var presenter: StartGamePresentationLogic?
    var service: StartGameService?
    
    func makeRequest(request: StartGame.Model.Request.RequestType) {
        if service == nil {
            service = StartGameService()
        }
        
        switch request {
        case .startButtonTouch:
            presenter?.presentData(response: StartGame.Model.Response.ResponseType.presentDifficults)
        case .continueButtonTouch:
            presenter?.presentData(response: StartGame.Model.Response.ResponseType.presentSavedGame)
        case .difficultButtonTouch(index: let index):
            service?.getDifficult(forIndex: index, completion: { difficult in
                self.presenter?.presentData(response: StartGame.Model.Response.ResponseType.presentNewGame(difficult: difficult))
            })
        case .checkSavedGame:
            if let isEnable = service?.checkSavedGame() {
                presenter?.presentData(response: StartGame.Model.Response.ResponseType.presentContinueButton(isEnable: isEnable))
            }
        case .gameOver:
            presenter?.presentData(response: StartGame.Model.Response.ResponseType.presentGameOver)
        case .pause:
            presenter?.presentData(response: StartGame.Model.Response.ResponseType.presentPause)
        }
    }
    
}
