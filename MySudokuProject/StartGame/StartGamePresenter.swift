//
//  StartGamePresenter.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 21.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol StartGamePresentationLogic {
    func presentData(response: StartGame.Model.Response.ResponseType)
}

class StartGamePresenter: StartGamePresentationLogic {
    weak var viewController: StartGameDisplayLogic?
    
    func presentData(response: StartGame.Model.Response.ResponseType) {
        
        switch response {
        case .presentDifficults:
            viewController?.displayData(viewModel: StartGame.Model.ViewModel.ViewModelData.displayDifficults)
        case .presentSavedGame:
            viewController?.displayData(viewModel: StartGame.Model.ViewModel.ViewModelData.displaySavedGame)
        case .presentNewGame(difficult: let difficult):
            viewController?.displayData(viewModel: StartGame.Model.ViewModel.ViewModelData.displayNewGame(difficult: difficult))
        case .presentGameOver:
            viewController?.displayData(viewModel: StartGame.Model.ViewModel.ViewModelData.displayGameOver)
        case .presentPause:
            viewController?.displayData(viewModel: StartGame.Model.ViewModel.ViewModelData.displayPause)
        case .presentContinueButton(isEnable: let isEnable):
            viewController?.displayData(viewModel: StartGame.Model.ViewModel.ViewModelData.displayContinueButton(isEnable: isEnable))
        }
    }
    
}
