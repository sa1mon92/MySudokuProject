//
//  SudokuGameInteractor.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 07.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SudokuGameBusinessLogic {
    func makeRequest(request: SudokuGame.Model.Request.RequestType)
}

class SudokuGameInteractor: SudokuGameBusinessLogic {
    
    var presenter: SudokuGamePresentationLogic?
    var service: SudokuGameService?
    
    private var timer: Timer?
    private var time: Double = 0 {
        willSet {
            UserDefaults.standard.set(newValue, forKey: "Time")
        }
    }
    
    func makeRequest(request: SudokuGame.Model.Request.RequestType) {
        if service == nil {
            service = SudokuGameService()
        }
        
        switch request {
        case .pauseButtonTouch:
            stopTimer()
            presenter?.presentData(response: SudokuGame.Model.Response.ResponseType.presentPause)
        case .eraserButtonTouch:
            service?.touchEraserButton()
            service?.getGame { game in
                self.presentData(game: game)
            }
        case .pencilButtonTouch:
            service?.touchPencilButton()
            service?.getGame { game in
                self.presentData(game: game)
            }
        case .lampButtonTouch:
            service?.touchHintButton()
            service?.getGame { game in
                self.presentData(game: game)
                self.service?.gameDidChanged()
            }
        case .numberButtonTouch(index: let index):
            service?.touchNumberButton(withIndex: index)
            service?.getGame { game in
                self.presentData(game: game)
                self.service?.gameDidChanged()
            }
        case .selectCell(index: let index):
            service?.setSelectedCell(forIndex: index)
            service?.getGame { game in
                self.presentData(game: game)
            }
        case .startNewGame(withDifficult: let difficult):
            service?.startNewGame(withDifficult: difficult, completion: { game in
                self.presentData(game: game)
                self.startTimer()
                self.service?.gameDidChanged()
            })
        case .startSavedGame:
            service?.startSavedGame(completion: { game in
                self.presentData(game: game)
                self.loadSavedTimer()
            })
        }
    }
    
    private func presentData(game: SudokuGameModel?) {
        
        guard let game = game else { return }
        
        if game.getErrorsCount() == 5 {
            deleteTimer()
            self.presenter?.presentData(response: SudokuGame.Model.Response.ResponseType.presentGameOver)
        } else {
            self.presenter?.presentData(response: SudokuGame.Model.Response.ResponseType.presentGame(game: game, selectedCellIndex: self.service?.getSelectedCell(), pencilIsEnable: service?.getPetncilOn() ?? false))
        }
    }
}

// MARK: - Timer

extension SudokuGameInteractor {
    
    private func loadSavedTimer() {
        if let time = UserDefaults.standard.object(forKey: "Time") as? Double {
            self.time = time
            startTimer()
        }
    }
 
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func deleteTimer() {
        stopTimer()
        UserDefaults.standard.removeObject(forKey: "Time")
    }
    
    @objc private func timerUpdate() {
        
        time += 1
        let hours = Int(time / 3600)
        let minutes = Int((time.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))

        var text: String!
        if hours < 1 {
            text = String(format: "%02d:%02d", minutes, seconds)
        } else {
            text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        presenter?.presentData(response: SudokuGame.Model.Response.ResponseType.presentTimer(text: text))
    }
}
