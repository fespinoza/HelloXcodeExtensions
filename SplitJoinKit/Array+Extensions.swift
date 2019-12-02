//
//  Array+Extensions.swift
//  SplitJoinKit
//
//  Created by Felipe Espinoza on 02/12/2019.
//  Copyright © 2019 Felipe Espinoza. All rights reserved.
//

import Foundation

extension Array where Element == String {
    /// Returns the index of the first line in an array of strings that matches the given predicate
    /// - Parameters:
    ///   - predicate: predicate that determines that the line passes the check (type `Bool?`).
    ///    if the predicate returns `false` or `true` loop will be broken, if the predicate returns `nil` then, the next line will be checked.
    ///   - range: range of indexes within the array to do the search
    ///   - reversed: order on how the lines will be traversed (default `false`)
    func searchFirstMatch(of predicate: (String) -> Bool?, within range: Range<Int>, reversed: Bool = false) -> Int? {
        if reversed {
            for index in range.reversed() {
                let line = self[index]
                if let satisfiedPredicate = predicate(line) {
                    return satisfiedPredicate ? index : nil
                }
            }
        } else {
            for index in range {
                let line = self[index]
                if let satisfiedPredicate = predicate(line) {
                    return satisfiedPredicate ? index : nil
                }
            }
        }

        return nil
    }
}
