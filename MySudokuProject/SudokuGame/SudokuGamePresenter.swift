//
//  SudokuGamePresenter.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 07.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SudokuGamePresentationLogic {
    func presentData(response: SudokuGame.Model.Response.ResponseType)
}

class SudokuGamePresenter: SudokuGamePresentationLogic {
    weak var viewController: SudokuGameDisplayLogic?
    
    private var pencilOn: Bool = false
    private var selectedCellIndex: IndexPath?
    
    func presentData(response: SudokuGame.Model.Response.ResponseType) {
        switch response {
        case .presentGame(game: let game, selectedCellIndex: let index, pencilIsEnable: let pencilIsEnable):
            
            selectedCellIndex = index
            pencilOn = pencilIsEnable
            
            let viewModel = SudokuGameViewModel(lampCount: game.getHintsCount(),
                                                errorCount: game.getErrorsCount(),
                                                pencilIsEnable: pencilOn,
                                                cells: fetchCells(forGame: game))
            viewController?.displayData(viewModel: SudokuGame.Model.ViewModel.ViewModelData.displayGame(viewModel: viewModel))
        case .presentGameOver:
            viewController?.displayData(viewModel: SudokuGame.Model.ViewModel.ViewModelData.displayGameOver)
        case .presentPause:
            viewController?.displayData(viewModel: SudokuGame.Model.ViewModel.ViewModelData.displayPause)
        case .presentTimer(text: let text):
            viewController?.displayData(viewModel: SudokuGame.Model.ViewModel.ViewModelData.presentTimer(text: text))
        }
    }
    
    private func fetchCells(forGame game: SudokuGameModel) -> [SudokuGameViewModel.Cell] {
        
        var cells = [SudokuGameViewModel.Cell]()
        for section in 0...8 {
            for row in 0...8 {
                let index = IndexPath(row: row, section: section)
                let cellType = cellType(index: index, game: game)
                var numberValue: Int?
                if game.getDefaultAnswer(forIndex: index) != nil {
                    numberValue = game.getDefaultAnswer(forIndex: index)
                } else {
                    numberValue = game.getUserAnswer(forIndex: index)
                }
                let pencilValues = game.getPencilValues(forIndex: index)
                let cell = SudokuGameViewModel.Cell(index: index,
                                                    type: cellType,
                                                    bgColor: getColor(forCell: index, value: numberValue, game: game),
                                                    numberValue: numberValue,
                                                    pencilValues: pencilValues)
                cells.append(cell)
            }
        }
        
        return cells
    }
    
    private func getColor(forCell index: IndexPath, value: Int?, game: SudokuGameModel) -> UIColor? {
        
        guard let selectedCellIndex = selectedCellIndex else { return nil }
        
        var selectCellColor: UIColor?
        var otherSelectCellColor: UIColor?
        
        if pencilOn {
            selectCellColor = UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 1.0)
            otherSelectCellColor = UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1.0)
        } else {
            selectCellColor = UIColor(red: 82 / 255, green: 189 / 255, blue: 235 / 255, alpha: 1.0)
            otherSelectCellColor = UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 1.0)
        }
        
        if index == selectedCellIndex {
            return selectCellColor
        }
        
        if (index.row == selectedCellIndex.row || index.section == selectedCellIndex.section || index.blockNumber() == selectedCellIndex.blockNumber()) && index != selectedCellIndex {
            return otherSelectCellColor
        }
        
        if (value == game.getDefaultAnswer(forIndex: selectedCellIndex) || value == game.getUserAnswer(forIndex: selectedCellIndex)) && value != nil  && index != selectedCellIndex && cellType(index: selectedCellIndex, game: game) != .Error {
            return selectCellColor
        }
        
        return nil
    }
    
    private func cellType(index: IndexPath, game: SudokuGameModel) -> SudokuGameViewModel.SudokuGameCellType {
        
        if game.getDefaultAnswer(forIndex: index) != nil {
            return .Default
        }
        
        if game.getUserAnswer(forIndex: index) == game.getGameAnswer(forIndex: index) {
            return .User
        }
        
        if game.getUserAnswer(forIndex: index) != game.getGameAnswer(forIndex: index) && game.getUserAnswer(forIndex: index) != nil {
            return .Error
        }
        
        if game.getUserAnswer(forIndex: index) == nil && game.getPencilValues(forIndex: index) != nil {
            return .Pencil
        }
        return .Unknown
    }
    
}
