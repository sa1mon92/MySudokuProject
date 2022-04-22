//
//  StartGameModels.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 21.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum StartGame {
    
    enum Model {
        struct Request {
            enum RequestType {
                case startButtonTouch
                case continueButtonTouch
                case difficultButtonTouch(index: Int)
                case checkSavedGame
                case gameOver
                case pause
            }
        }
        struct Response {
            enum ResponseType {
                case presentDifficults
                case presentSavedGame
                case presentNewGame(difficult: SudokuGameDifficult)
                case presentGameOver
                case presentPause
                case presentContinueButton(isEnable: Bool)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayDifficults
                case displaySavedGame
                case displayNewGame(difficult: SudokuGameDifficult)
                case displayGameOver
                case displayPause
                case displayContinueButton(isEnable: Bool)
            }
        }
    }
    
}
