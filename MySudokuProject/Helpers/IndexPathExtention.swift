//
//  IndexPathExtention.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 13.04.2022.
//

import Foundation

extension IndexPath {
    
    func blockNumber() -> Int {
        if self.count == 2 {
            let index = (self.section,self.item)
            switch index {
                case (0...2,0...2): return 0
                case (0...2,3...5): return 1
                case (0...2,6...8): return 2
                case (3...5,0...2): return 3
                case (3...5,3...5): return 4
                case (3...5,6...8): return 5
                case (6...8,0...2): return 6
                case (6...8,3...5): return 7
                case (6...8,6...8): return 8
                default: return 9
            }
        }
        return 9
    }
}
