//
//  Utils.swift
//  SplitJoin
//
//  Created by Felipe Espinoza on 19/11/2019.
//  Copyright © 2019 Felipe Espinoza. All rights reserved.
//

import Foundation

public struct Utils {
    private static let splitPattern: String = #"(?<spacing>\s*)(?<preContent>[^\(]*)\((?<content>.*)\)(?<suffix>[^\)]*)"#

    public static func split(_ string: String, spacing: String = "    ") -> String {
        let stringRange = NSRange(string.startIndex..<string.endIndex, in: string)

        guard
            let regex = try? NSRegularExpression(pattern: splitPattern, options: []),
            let match = regex.firstMatch(in: string, options: [], range: stringRange)
        else {
            return string
        }

        let preLineSpacing = string.matchingString(from: match, withName: "spacing")
        let preContent = string.matchingString(from: match, withName: "preContent")
        let suffix = string.matchingString(from: match, withName: "suffix")

        let content = string.matchingString(from: match, withName: "content")
            .replacingOccurrences(of: ", ", with: "%", options: [], range: nil)
            .split(separator: "%")
            .joined(separator: ",\n\(preLineSpacing)\(spacing)")
        let newContent = "(\n\(preLineSpacing)\(spacing)\(content)\n\(preLineSpacing))"

        return preLineSpacing + preContent + newContent + suffix
    }

    public static func join(_ string: String) -> String {
        string
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: #",\s+"#, with: ", ", options: .regularExpression)
            .replacingOccurrences(of: #"\(\s+"#, with: "(", options: .regularExpression)
            .replacingOccurrences(of: #"\s+\)"#, with: ")", options: .regularExpression)
    }

    public static func splittable(line: String) -> Bool {
        let stringRange = NSRange(line.startIndex..<line.endIndex, in: line)

        guard
            let regex = try? NSRegularExpression(pattern: splitPattern, options: [])
        else {
            return false
        }

        return regex.firstMatch(in: line, options: [], range: stringRange) != nil
    }

    public static func joinableLines(for string: String, in lineNumber: Int) -> CodeRange? {
        var start: Int? = nil
        var end: Int? = nil

        let lines = string.split(separator: "\n").compactMap({ String($0) })
        let selectedLine = lines[lineNumber]

        if selectedLine.contains("(") && !selectedLine.contains(")") {
            start = lineNumber
            end = lines.searchFirstMatch(of: hasClosignParenthesis, within: (lineNumber+1)..<lines.count)
        } else if selectedLine.contains(")") && !selectedLine.contains("(") {
            start = lines.searchFirstMatch(of: hasOpeningParenthesis, within: 0..<lineNumber, reversed: true)
            end = lineNumber
        } else {
            // searching up
            start = lines.searchFirstMatch(of: onlyOpeningParenthesis, within: 0..<lineNumber, reversed: true)
            end = lines.searchFirstMatch(of: onlyClosingParenthesis, within: (lineNumber + 1)..<lines.count)
        }

        guard
            let _start = start,
            let _end = end
        else {
            return nil
        }

        let relevantLines = lines[_start..._end].map({ $0 })

        return CodeRange(startIndex: _start, endIndex: _end, lines: relevantLines)
    }

    private static  func hasOpeningParenthesis(_ line: String) -> Bool? {
        line.contains("(") ? true : nil
    }

    private static func hasClosignParenthesis(_ line: String) -> Bool? {
        line.contains(")") ? true : nil
    }

    private static func onlyClosingParenthesis(_ line: String) -> Bool? {
        if line.contains("(") {
            return false
        } else if line.contains(")") {
            return true
        }
        return nil
    }

    private static func onlyOpeningParenthesis(_ line: String) -> Bool? {
        if line.contains(")") {
            return false
        } else if line.contains("(") {
            return true
        }
        return nil
    }
}

private extension String {
    func matchingString(from match: NSTextCheckingResult, withName name: String) -> String {
        let nameRange = match.range(withName: name)
        guard
            let range = Range(nameRange, in: self),
            nameRange.location != NSNotFound
        else {
            return ""
        }

        return String(self[range])
    }
}
