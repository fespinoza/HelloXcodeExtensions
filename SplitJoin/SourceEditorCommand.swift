//
//  SourceEditorCommand.swift
//  SplitJoin
//
//  Created by Felipe Espinoza on 05/11/2019.
//  Copyright © 2019 Felipe Espinoza. All rights reserved.
//

import Foundation
import XcodeKit

let joined = """
    static let attributesStyle = AdPageLabelValuePairsViewStyle(titleFont: .caption, titleColor: .textPrimary, titleNumberOfLines: 1, titleColomnFixedWidth: 130, valueFont: .caption, valueColor: .textPrimary, valueNumberOfLines: 1, extraRowSpacing: .smallSpacing)
"""

let splitted = """
    static let attributesStyle = AdPageLabelValuePairsViewStyle(
        titleFont: .caption,
        titleColor: .textPrimary,
        titleNumberOfLines: 1,
        titleColomnFixedWidth: 130,
        valueFont: .caption,
        valueColor: .textPrimary,
        valueNumberOfLines: 1,
        extraRowSpacing: .smallSpacing
    )
"""

struct CodeRange {
    let startIndex: Int
    let endIndex: Int
    let lines: [String]

    init(startIndex: Int, endIndex: Int, lines: [String]) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.lines = lines
    }

    var combinedLines: String {
        lines.joined(separator: "\n")
    }
}

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.

        // NSMutableArray<XCSourceTextRange>
        // XCSourceTextRange.start // XCSourceTextPosition (column: Int, line: Int)

        /*
         Split only works with one line at a time

         IDEA: Split can potentially be invoked without a selection, but the cursor being inside a parenthesis

         Utils.split(text) // splitted line
         */

        /*
         Join requires multiple lines
         Join probably requires the selection of lines to attempt to "join"

         Utils.join(text) // join line
         */

        /*
         If the count of selected lines == 1 => split ELSE join
         */

        let selectedLines = self.selectedLines(in: invocation.buffer)
        guard let selection = selectedLines.first else {
            completionHandler(nil)
            return
        }

        print(">>>> selected.lines.count = \(selection.lines.count)")

        if selection.lines.count > 1 {
            let result = join(selection.lines)

            invocation.buffer.lines.removeObjects(in: NSRange(location: selection.startIndex, length: selection.lines.count))
            invocation.buffer.lines.insert(result, at: selection.startIndex)
        } else {
            selectedLines.forEach { codeRange in
                let index = codeRange.startIndex
                let line = codeRange.combinedLines
                let splittedLines = split(line)

                invocation.buffer.lines.removeObject(at: index)
                invocation.buffer.lines.insert(
                    splittedLines,
                    at: IndexSet(integersIn: index..<(index + splittedLines.count))
                )
            }
        }

        completionHandler(nil)
    }

    private func join(_ lines: [String]) -> String {
        Utils.join(lines.joined(separator: "\n"))
    }

    private func split(_ text: String) -> [String] {
        Utils.split(text).split(separator: "\n").compactMap({ String($0) })
    }

    private func selectedLines(in buffer: XCSourceTextBuffer) -> [CodeRange] {
        buffer
            .selections
            .compactMap({ $0 as? XCSourceTextRange })
            .compactMap { range in
                let startLine = range.start.line
                let endLine = range.end.line
                let lines = (startLine...endLine).compactMap({ buffer.lines[$0] as? String })
                return CodeRange(startIndex: startLine, endIndex: endLine, lines: lines)
        }
    }

    private func spacingString(for buffer: XCSourceTextBuffer) -> String {
        return buffer.usesTabsForIndentation ? "\t" : String(repeating: " ", count: buffer.indentationWidth)
    }

    // join to ternary operator
    // replace "if" for "guard let"
}
