//
//  ArrayExtention.swift
//  MySudokuProject
//
//  Created by Дмитрий Садырев on 09.04.2022.
//

import Foundation

extension Array {
    func contains<T>(_ obj: T) -> Bool where T: Equatable {
        return !self.filter({$0 as? T == obj}).isEmpty
    }
}
