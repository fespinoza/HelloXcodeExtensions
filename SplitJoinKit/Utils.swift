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
        guard
            let match = string.firstMatch(with: splitPattern)
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
        return line.firstMatch(with: splitPattern) != nil
    }

    public static func joinableLines(for lines: [String], in lineNumber: Int) -> CodeRange? {
        var start: Int? = nil
        var end: Int? = nil
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

    private static func hasOpeningParenthesis(_ line: String) -> Bool? {
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

// MARK: - Lazy Var
extension Utils {
    public static func toLazyVar(line: String, spacing: String = "    ") -> String {
        let pattern = #"(?<preSpacing>\s*)(?<modifier>let|var)\s+(?<variableName>\w+)\s+=\s+(?<value>.+)"#

        guard
            let match = line.firstMatch(with: pattern)
        else {
            return line
        }

        let preSpacing = line.matchingString(from: match, withName: "preSpacing")
        let variableName = line.matchingString(from: match, withName: "variableName")
        let value = line.matchingString(from: match, withName: "value")
        let valueType = extractType(from: value)
        let simpleVariableName = self.simpleVariableName(from: valueType)

        return """
        \(preSpacing)lazy var \(variableName): \(valueType) = {
        \(preSpacing + spacing)let \(simpleVariableName) = \(value)
        \(preSpacing + spacing)return \(simpleVariableName)
        \(preSpacing)}()
        """
    }

    public static func toNormalConstant(lines: [String]) -> String? {
        guard lines.count > 2 else {
            return nil
        }

        let firstLine = lines[0]
        let secondLine = lines[1]

        let firstPattern = #"\s*lazy var (?<variableName>\w+)\s*:.*"#
        let secondPattern = #"\s*let \w+\s+=\s+(?<value>.*)"#

        guard
            let firstMatch = firstLine.firstMatch(with: firstPattern),
            let secondMatch = secondLine.firstMatch(with: secondPattern)
        else {
            return nil
        }

        let variableName = firstLine.matchingString(from: firstMatch, withName: "variableName")
        let value = secondLine.matchingString(from: secondMatch, withName: "value")

        return "let \(variableName) = \(value)"
    }

    private static func extractType(from line: String) -> String {
        let pattern = #"(?<valueType>[^\(]+).*"#
        guard let match = line.firstMatch(with: pattern) else {
            return line
        }
        return line.matchingString(from: match, withName: "valueType")
    }

    private static func simpleVariableName(from valueType: String) -> String {
        let nonUIKitValueType = valueType.replacingOccurrences(of: "UI", with: "")
        let (firstCharacter, restString) = nonUIKitValueType.splitInFirstAndRest()
        return firstCharacter.lowercased() + restString
    }
}
