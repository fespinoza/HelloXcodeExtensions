//
//  StringSelectionTests.swift
//  SplitJoinKitTests
//
//  Created by Felipe Espinoza on 28/11/2019.
//  Copyright © 2019 Felipe Espinoza. All rights reserved.
//

import XCTest
import SplitJoinKit

class StringSelectionTests: XCTestCase {
    let sampleCode = """
        guard
            let regex = try? NSRegularExpression(pattern: splitPattern, options: []),
            let match = regex.firstMatch(in: string, options: [], range: stringRange)
        else {
            return string
        }

        let preLineSpacing = string.matchingString(
            from: match,
            withName: "spacing"
        )
        let preContent = string.matchingString(from: match, withName: "preContent")
        let suffix = string.matchingString(from: match, withName: "suffix")

        let content = string.matchingString(from: match, withName: "content")
            .replacingOccurrences(of: ", ", with: "%", options: [], range: nil)
            .split(separator: "%")
            .joined(separator: ",\n")
        let newContent = "content"
    """

    let joinableCode = """
        let preLineSpacing = string.matchingString(
            from: match,
            withName: "spacing"
        )
    """
    var joinableCodeLines: [String] {
        joinableCode
            .split(separator: "\n")
            .compactMap({ String($0) })
    }

    func testSelectingTextInsideParenthesis() {
        let lineNumber = 7 // from: match,
        guard let resultRange = joinableLines(for: sampleCode, in: lineNumber) else {
            XCTFail("There should have been a result range")
            return
        }

        XCTAssertEqual(resultRange.startIndex, 6)
        XCTAssertEqual(resultRange.endIndex, 9)
        XCTAssertEqual(resultRange.lines, joinableCodeLines)
    }

    func testSelectingTextInsideParenthesisStartCase() {
        let lineNumber = 6 // let preLineSpacing = string.matchingString(
        guard let resultRange = joinableLines(for: sampleCode, in: lineNumber) else {
            XCTFail("There should have been a result range")
            return
        }
        XCTAssertEqual(resultRange.startIndex, 6)
        XCTAssertEqual(resultRange.endIndex, 9)
        XCTAssertEqual(resultRange.lines, joinableCodeLines)
    }

    func testSelectingTextInsideParenthesisEndCase() {
        let lineNumber = 9 // )
        guard let resultRange = joinableLines(for: sampleCode, in: lineNumber) else {
            XCTFail("There should have been a result range")
            return
        }
        XCTAssertEqual(resultRange.startIndex, 6)
        XCTAssertEqual(resultRange.endIndex, 9)
        XCTAssertEqual(resultRange.lines, joinableCodeLines)
    }

    func testSelectingTextWithParenthesisButNotJoinable() {
        let lineNumber = 10 // let preContent = string.matchingString(from: match, withName: "preContent")
        let resultRange = joinableLines(for: sampleCode, in: lineNumber)
        XCTAssertNil(resultRange)
    }

    func testSelectingTextWithNoParenthesis() {
        let lineNumber = 4 // return string
        let resultRange = joinableLines(for: sampleCode, in: lineNumber)
        XCTAssertNil(resultRange)
    }

    private func joinableLines(for string: String, in lineNumber: Int) -> CodeRange? {
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

    private func hasOpeningParenthesis(_ line: String) -> Bool? {
        line.contains("(") ? true : nil
    }

    private func hasClosignParenthesis(_ line: String) -> Bool? {
        line.contains(")") ? true : nil
    }

    private func onlyClosingParenthesis(_ line: String) -> Bool? {
        if line.contains("(") {
            return false
        } else if line.contains(")") {
            return true
        }
        return nil
    }

    private func onlyOpeningParenthesis(_ line: String) -> Bool? {
        if line.contains(")") {
            return false
        } else if line.contains("(") {
            return true
        }
        return nil
    }
}

extension Optional where Wrapped == Bool {
    var valueOrFalse: Bool {
        switch self {
        case .none: return false
        case .some(let value): return value
        }
    }
}

extension Array where Element == String {
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
