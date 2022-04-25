//
//  SaveManager.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 25.04.2022.
//

import UIKit
import CoreData

protocol SaveService {
    
    func save(gameModel: SudokuGameModel?)
    func getSavedGame() -> SudokuGameModel?
    func deleteSave()
}

class SaveManager: SaveService {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save(gameModel: SudokuGameModel?) {
        
        guard let gameModel = gameModel,
              let entity = NSEntityDescription.entity(forEntityName: "Game", in: context)
        else { return }
        
        var game: Game!

        if let fetchedGame = fetchGame() {
            game = fetchedGame
        } else {
            game = NSManagedObject(entity: entity, insertInto: context) as? Game
        }

        game.hintsCount = Int16(gameModel.getHintsCount())
        game.errorCount = Int16(gameModel.getErrorsCount())
        game.gameAnswersArray = gameModel.getGameAnswers() as NSObject
        game.userAnswersArray = gameModel.getUserAnswers() as NSObject
        game.defaultAnswersArray = gameModel.getDefaultAnswers() as NSObject
        game.pencils = gameModel.getPencils() as? NSObject
        
        saveContext()
    }
    
    func getSavedGame() -> SudokuGameModel? {
        
        guard let game = fetchGame(),
              let gameAnswersArray = game.gameAnswersArray as? [[Int]],
              let defaultAnswersArray = game.defaultAnswersArray as? [[Int?]],
              let userAnswersArray = game.userAnswersArray as? [[Int?]]
        else { return nil }
        
        var pencils = [Pencil]()
        if game.pencils != nil {
            pencils = game.pencils as! [Pencil]
        }
        
        return SudokuGameModel(hintsCount: Int(game.hintsCount),
                                        errorCount: Int(game.errorCount),
                                        gameAnswersArray: gameAnswersArray,
                                        defaultAnswersArray: defaultAnswersArray,
                                        userAnswersArray: userAnswersArray,
                                        pencils: pencils)
    }
    
    func deleteSave() {
        
        if let game = fetchGame() {
            context.delete(game)
        }
        saveContext()
    }
    
    private func fetchGame() -> Game? {
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        
        do {
            let games = try context.fetch(fetchRequest)
            return games.first
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
