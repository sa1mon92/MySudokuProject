//
//  SudokuGameWorker.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 07.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import CoreData

class SudokuGameService {
    
    private var gameModel: SudokuGameModel?
    private var selectedIndex: IndexPath?
    private var pencilOn: Bool = false
    private let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func gameDidChanged() {
        if let errorsCount = gameModel?.getErrorsCount(), errorsCount < 5 {
            DispatchQueue.global(qos: .utility).async {
                self.save(gameModel: self.gameModel)
            }
        } else {
            self.deleteSave()
        }
    }
    
    func startSavedGame(completion: @escaping (SudokuGameModel) -> Void) {
        
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        
        do {
            let games = try context.fetch(fetchRequest)
            guard let game = games.first,
                  let gameAnswersArray = game.gameAnswersArray as? [[Int]],
                  let defaultAnswersArray = game.defaultAnswersArray as? [[Int?]],
                  let userAnswersArray = game.userAnswersArray as? [[Int?]]
            else { return }
            
            var pencils = [Pencil]()
            if game.pencils != nil {
                pencils = game.pencils as! [Pencil]
            }
            
            let gameModel = SudokuGameModel(hintsCount: Int(game.hintsCount),
                                            errorCount: Int(game.errorCount),
                                            gameAnswersArray: gameAnswersArray,
                                            defaultAnswersArray: defaultAnswersArray,
                                            userAnswersArray: userAnswersArray,
                                            pencils: pencils)
            self.gameModel = gameModel
            completion(gameModel)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func deleteSave() {
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        
        do {
            let games = try context.fetch(fetchRequest)
            for game in games {
                context.delete(game)
            }
            try context.save()
            UserDefaults.standard.removeObject(forKey: "SaveGame")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func save(gameModel: SudokuGameModel?) {
        
        guard let gameModel = gameModel else { return }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Game", in: context) else {
            return
        }
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        var game: Game!
        
        do {
            let games = try context.fetch(fetchRequest)
            if games.first != nil {
                game = games.first
            } else {
                game = NSManagedObject(entity: entity, insertInto: context) as? Game
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        game.hintsCount = Int16(gameModel.getHintsCount())
        game.errorCount = Int16(gameModel.getErrorsCount())
        game.gameAnswersArray = gameModel.getGameAnswers() as NSObject
        game.userAnswersArray = gameModel.getUserAnswers() as NSObject
        game.defaultAnswersArray = gameModel.getDefaultAnswers() as NSObject
        game.pencils = gameModel.getPencils() as? NSObject
        
        do {
            try context.save()
            UserDefaults.standard.set(true, forKey: "SaveGame")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func getPetncilOn() -> Bool {
        return pencilOn
    }
    
    func touchPencilButton() {
        if pencilOn == false {
            pencilOn = true
        } else {
            pencilOn = false
        }
    }
    
    func touchEraserButton() {
        
        guard let selectedIndex = selectedIndex else { return }
        
        gameModel?.removeUserAnswer(forIndex: selectedIndex)
    }
    
    func startNewGame(withDifficult difficult: SudokuGameDifficult, completion: @escaping (SudokuGameModel) -> Void) {
        SudokuGenerator.generateSudokuGame(difficult: difficult) { game in
            self.gameModel = game
            completion(game)
        }
    }
    
    func setSelectedCell(forIndex index: IndexPath) {
        selectedIndex = index
    }
    
    func getSelectedCell() -> IndexPath? {
        return selectedIndex
    }
    
    func getGame(completion: @escaping (SudokuGameModel?) -> Void) {
        completion(gameModel)
    }
    
    func touchHintButton() {
        
        guard let hintsCount = gameModel?.getHintsCount(), hintsCount > 0 else { return }
        
        var index: IndexPath!
        
        repeat {
            index = IndexPath(row: Int.random(in: 0..<9), section: Int.random(in: 0..<9))
        } while gameModel?.getDefaultAnswer(forIndex: index) != nil || gameModel?.getUserAnswer(forIndex: index) != nil
        
        if let answer = gameModel?.getGameAnswer(forIndex: index) {
            gameModel?.setUserAnswer(answer, forIndex: index)
            gameModel?.removeAllPencils(forIndex: index)
            gameModel?.spendHint()
        }
    }
    
    func touchNumberButton(withIndex index: Int) {
        
        guard let selectedIndex = selectedIndex else { return }
        
        let value = index + 1
        
        if pencilOn {
            if gameModel?.checkPencilValue(value, forIndex: selectedIndex) == true {
                gameModel?.removePencilValue(value, forIndex: selectedIndex)
            } else {
                gameModel?.setPencilValue(value, forIndex: selectedIndex)
            }
        } else {
            guard gameModel?.getDefaultAnswer(forIndex: selectedIndex) == nil,
                  gameModel?.getGameAnswer(forIndex: selectedIndex) != gameModel?.getUserAnswer(forIndex: selectedIndex)
            else { return }
            
            gameModel?.setUserAnswer(value, forIndex: selectedIndex)
            
            if gameModel?.getGameAnswer(forIndex: selectedIndex) != value {
                gameModel?.addError()
            } else {
                gameModel?.removeAllPencils(forIndex: selectedIndex)
            }
            
            gameModel?.getPencils()?.filter({ $0.index.blockNumber() == selectedIndex.blockNumber() || $0.index.row == selectedIndex.row || $0.index.section == selectedIndex.section }).forEach { pencil in
                self.gameModel?.removePencilValue(value, forIndex: pencil.index)
            }
        }
    }
}
