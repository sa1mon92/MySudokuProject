//
//  SudokuGameViewModel.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 26.04.2022.
//

import UIKit

struct SudokuGameViewModel {
    
    enum SudokuGameCellType {
        case Default
        case User
        case Error
        case Pencil
        case Unknown
    }
    
    var lampCount: Int
    var errorCount: Int
    var pencilIsEnable: Bool
    var cells: [Cell]
    
    struct Cell: Equatable {
        var index: IndexPath
        var type: SudokuGameCellType
        var bgColor: UIColor?
        var numberValue: Int?
        var pencilValues: [Int]?
    }
}
