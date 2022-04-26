//
//  SudokuGameModel.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 26.04.2022.
//

import Foundation

struct Pencil {
    let index: IndexPath
    var values: [Int]
    
    mutating func addValue(_ value:Int) {
        if !values.contains(value) {
            values.append(value)
        }
    }
    
    mutating func removeValue(_ value:Int) {
        if let index = values.firstIndex(of: value) {
            values.remove(at: index)
        }
    }
}

struct SudokuGameModel {
    
    private var hintsCount: Int
    private var errorCount: Int
    
    private let gameAnswersArray: [[Int]]
    private let defaultAnswersArray: [[Int?]]
    private var userAnswersArray: [[Int?]]
    private var pencils: [Pencil]?
    
    init(hintsCount: Int, errorCount: Int, gameAnswersArray: [[Int]], defaultAnswersArray: [[Int?]], userAnswersArray: [[Int?]], pencils: [Pencil]?) {
        self.hintsCount = hintsCount
        self.errorCount = errorCount
        self.gameAnswersArray = gameAnswersArray
        self.defaultAnswersArray = defaultAnswersArray
        self.userAnswersArray = userAnswersArray
        self.pencils = pencils
    }
    
    init(hintsCount: Int, gameAnswersArray: [[Int]], defaultAnswersArray: [[Int?]]) {
        self.hintsCount = hintsCount
        self.errorCount = 0
        self.gameAnswersArray = gameAnswersArray
        self.defaultAnswersArray = defaultAnswersArray
        self.userAnswersArray = Array(repeating: Array(repeating: nil, count: 9), count: 9)
        self.pencils = nil
    }
    
    mutating func addError() {
        if errorCount < 5 {
            errorCount += 1
        }
    }
    
    func getGameAnswers() -> [[Int]] {
        return gameAnswersArray
    }
    
    func getUserAnswers() -> [[Int?]] {
        return userAnswersArray
    }
    
    func getDefaultAnswers() -> [[Int?]] {
        return defaultAnswersArray
    }
    
    func getErrorsCount() -> Int {
        return errorCount
    }
    
    func getHintsCount() -> Int {
        return hintsCount
    }
    
    mutating func spendHint() {
        if hintsCount > 0 {
            hintsCount -= 1
        }
    }
    
    func getPencils() -> [Pencil]? {
        return pencils
    }
    
    mutating func setUserAnswer(_ value: Int, forIndex index: IndexPath) {
        if defaultAnswersArray[index.section][index.row] == nil {
            userAnswersArray[index.section][index.row] = value
        }
    }
    
    mutating func removeUserAnswer(forIndex index: IndexPath) {
        if getGameAnswer(forIndex: index) != getUserAnswer(forIndex: index) {
            userAnswersArray[index.section][index.row] = nil
        }
    }
    
    func getGameAnswer(forIndex index: IndexPath) -> Int? {
        return gameAnswersArray[index.section][index.row]
    }
    
    func getUserAnswer(forIndex index: IndexPath) -> Int? {
        return userAnswersArray[index.section][index.row]
    }
    
    func getDefaultAnswer(forIndex index: IndexPath) -> Int? {
        return defaultAnswersArray[index.section][index.row]
    }
    
    func getPencilValues(forIndex index: IndexPath) -> [Int]? {
        
        guard let pencils = pencils else { return nil }
        
        for item in pencils {
            if item.index == index {
                return item.values
            }
        }
        return nil
    }
    
    func checkPencilValue(_ value: Int, forIndex index: IndexPath) -> Bool {
        
        guard let pencils = pencils else { return false }

        if let i = pencils.firstIndex(where: { $0.index == index }) {
            return pencils[i].values.contains(value)
        }
        return false
    }
    
    mutating func setPencilValue(_ value: Int, forIndex index: IndexPath) {
        
        guard getUserAnswer(forIndex: index) == nil && getDefaultAnswer(forIndex: index) == nil else { return }
        
        if pencils != nil {
            if let i = pencils!.firstIndex(where: { $0.index == index }) {
                pencils![i].addValue(value)
            } else {
                pencils?.append(Pencil(index: index, values: [value]))
            }
        } else {
            pencils = [Pencil(index: index, values: [value])]
        }
    }
    
    mutating func removePencilValue(_ value: Int, forIndex index: IndexPath) {
        
        guard let pencils = pencils,
              let i = pencils.firstIndex(where: { $0.index == index })
        else { return }

        self.pencils?[i].removeValue(value)
        
        if self.pencils?[i].values.count == 0 {
            self.pencils?.remove(at: i)
        }
    }
    
    mutating func removeAllPencils(forIndex index: IndexPath) {
        
        guard let pencils = pencils,
              let i = pencils.firstIndex(where: { $0.index == index })
        else { return }
        
        self.pencils?.remove(at: i)
    }
}
