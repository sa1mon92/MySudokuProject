//
//  StartGameWorker.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 21.04.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class StartGameService {

    func getDifficult(forIndex index: Int, completion: @escaping (SudokuGameDifficult) -> Void) {
        switch index {
        case 0:
            completion(.Easy)
        case 1:
            completion(.Normal)
        case 2:
            completion(.Hard)
        default: break
        }
    }
    
    func checkSavedGame() -> Bool {
        if UserDefaults.standard.object(forKey: "SaveGame") as? Bool == true {
            return true
        } else {
            return false
        }
    }
}
