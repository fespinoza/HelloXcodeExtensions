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
            for i in (lineNumber+1)..<lines.count {
                let line = lines[i]
                if line.contains(")") {
                    end = i
                    break
                }
            }
        } else if selectedLine.contains(")") && !selectedLine.contains("(") {
            end = lineNumber
            for i in (0..<lineNumber).reversed() {
                let line = lines[i]
                if line.contains("(") {
                    start = i
                    break
                }
            }
        } else {
            // searching up
            for i in (0..<lineNumber).reversed() {
                let line = lines[i]
                if line.contains(")") {
                    break
                } else if line.contains("(") {
                    start = i
                    break
                }
            }

            // searching down
            for i in (lineNumber+1)..<lines.count {
                let line = lines[i]
                if line.contains("(") {
                    break
                } else if line.contains(")") {
                    end = i
                    break
                }
            }
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
}
