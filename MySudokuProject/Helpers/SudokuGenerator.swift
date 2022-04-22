//
//  SudokuGenerator.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 18.04.2022.
//

import Foundation

class SudokuGenerator {
    
    private static let baseArray = [[1,2,3,4,5,6,7,8,9],[4,5,6,7,8,9,1,2,3],[7,8,9,1,2,3,4,5,6],[2,3,4,5,6,7,8,9,1],[5,6,7,8,9,1,2,3,4],[8,9,1,2,3,4,5,6,7],[3,4,5,6,7,8,9,1,2],[6,7,8,9,1,2,3,4,5],[9,1,2,3,4,5,6,7,8]]
    
    private static func mixRows(array: [[Int]]) -> [[Int]] {
        
        var newArray = [[Int]]()
        for i in 0...2 {
            let mixedRows = [(3 * i + 0),(3 * i + 1),(3 * i + 2)].shuffled()
            for j in mixedRows {
                newArray.append(array[j])
            }
        }
        return newArray
    }
    
    private static func mixSections(array: [[Int]]) -> [[Int]] {
        
        let mixedSections = [0,1,2].shuffled()
        var newArray = [[Int]]()
        for i in 0...2 {
            for j in 0...2{
                newArray.append(array[mixedSections[i] * 3 + j])
            }
        }
        return newArray
    }
    
    private static func transp(array: [[Int]]) -> [[Int]] {
        
        var newArray = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        for i in 0...8 {
            for j in 0...8 {
                newArray[j][i] = array[i][j]
            }
        }
        return newArray
    }
    
    private static func getGameAnwers() -> [[Int]] {
       
        var array = baseArray
        for _ in 0...5 {
            array = mixRows(array: array)
            array = mixSections(array: array)
            array = transp(array: array)
        }
        return array
    }
    
    private static func countEmptyRows(array: [[Int?]]) -> Int {
        
        var newArray = array
        var count = 0
        
        for row in newArray {
            if row.filter({ $0 != nil }).count == 0 {
                count += 1
            }
        }
        for i in 0...8 {
            for j in 0...8 {
                newArray[j][i] = array[i][j]
            }
        }
        for row in newArray {
            if row.filter({ $0 != nil }).count == 0 {
                count += 1
            }
        }
        return count
    }
    
    private static func countEmptyItems(array: [[Int?]]) -> Int {
        
        var count = 0
        for i in 0...8 {
            for j in 0...8 {
                if array[i][j] == nil {
                    count += 1
                }
            }
        }
        return count
    }
    
    private static func getDefaultAnswers(for array: [[Int]], difficult: SudokuGameDifficult) -> [[Int?]] {
        
        var emptyRowsCount: Int!
        var emptyItemsCount: ClosedRange<Int>
        
        switch difficult {
        case .Easy:
            emptyRowsCount = 0
            emptyItemsCount = 46...51
        case .Normal:
            emptyRowsCount = 1
            emptyItemsCount = 51...56
        case .Hard:
            emptyRowsCount = 2
            emptyItemsCount = 56...61
        }
        
        var newArray: [[Int?]] = array
        repeat {
            let oldArray = newArray
            for row in 0...8 {
                newArray[row][Int.random(in: 0...8)] = nil
            }
            if countEmptyRows(array: newArray) > emptyRowsCount {
                newArray = oldArray
            }
        } while !emptyItemsCount.contains(countEmptyItems(array: newArray))
        
        return newArray
    }
    
    static func generateSudokuGame(difficult: SudokuGameDifficult, completion: @escaping (SudokuGameModel) -> Void) {
        
        let gameAnswers = getGameAnwers()
        var defaultAnswers = [[Int?]]()
        var hintsCount: Int!
        
        switch difficult {
        case .Easy:
            hintsCount = 3
            defaultAnswers = getDefaultAnswers(for: gameAnswers, difficult: .Easy)
        case .Normal:
            hintsCount = 2
            defaultAnswers = getDefaultAnswers(for: gameAnswers, difficult: .Normal)
        case .Hard:
            hintsCount = 1
            defaultAnswers = getDefaultAnswers(for: gameAnswers, difficult: .Hard)
        }
        
        let model = SudokuGameModel(hintsCount: hintsCount,
                                    gameAnswersArray: gameAnswers,
                                    defaultAnswersArray: defaultAnswers)
        completion(model)
    }
}
