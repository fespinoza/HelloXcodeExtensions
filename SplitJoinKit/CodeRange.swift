//
//  CodeRange.swift
//  SplitJoin
//
//  Created by Felipe Espinoza on 25/11/2019.
//  Copyright © 2019 Felipe Espinoza. All rights reserved.
//

import Foundation

public struct CodeRange {
    public let startIndex: Int
    public let endIndex: Int
    public let lines: [String]

    public init(startIndex: Int, endIndex: Int, lines: [String]) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.lines = lines
    }

    public var combinedLines: String {
        lines.joined(separator: "\n")
    }

    public var range: NSRange {
        NSRange(location: startIndex, length: lines.count)
    }
}
