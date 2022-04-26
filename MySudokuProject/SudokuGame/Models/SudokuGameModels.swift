//
//  SudokuGameModels.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 07.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum SudokuGame {
    
    enum Model {
        struct Request {
            enum RequestType {
                case selectCell(index: IndexPath)
                case pauseButtonTouch
                case eraserButtonTouch
                case pencilButtonTouch
                case lampButtonTouch
                case numberButtonTouch(index: Int)
                case startNewGame(withDifficult: SudokuGameDifficult)
                case startSavedGame
            }
        }
        struct Response {
            enum ResponseType {
                case presentGame(game: SudokuGameModel, selectedCellIndex: IndexPath?, pencilIsEnable: Bool)
                case presentPause
                case presentGameOver
                case presentTimer(text: String)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayGame(viewModel: SudokuGameViewModel)
                case displayPause
                case displayGameOver
                case presentTimer(text: String)
            }
        }
    }
    
}

struct PencilLabel {
    var label: UILabel
    var enable: Bool
    
    mutating func setupLabel(label: UILabel) {
        self.label = label
    }
    
    mutating func setupEnable(enable: Bool) {
        self.enable = enable
    }
}

enum SudokuGameDifficult {
    
    case Easy
    case Normal
    case Hard
}
