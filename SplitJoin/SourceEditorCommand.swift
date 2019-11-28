//
//  SourceEditorCommand.swift
//  SplitJoin
//
//  Created by Felipe Espinoza on 05/11/2019.
//  Copyright © 2019 Felipe Espinoza. All rights reserved.
//

import Foundation
import XcodeKit
import SplitJoinKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        let selectedLines = self.selectedLines(in: invocation.buffer)
        guard let selection = selectedLines.first else {
            completionHandler(nil)
            return
        }
        splitOrJoin(for: selection, in: invocation.buffer)
        completionHandler(nil)
    }

    private func splitOrJoin(for selection: CodeRange, in buffer: XCSourceTextBuffer) {
        if selection.lines.count > 1 {
            let result = join(selection.lines)

            buffer.lines.removeObjects(in: selection.range)
            buffer.lines.insert(result, at: selection.startIndex)
        } else {
            let index = selection.startIndex
            let line = selection.combinedLines
            let spacingString = self.spacingString(for: buffer)
            let splittedLines = split(line, spacingString: spacingString)

            buffer.lines.removeObject(at: index)
            buffer.lines.insert(splittedLines, at: IndexSet(integersIn: index..<(index + splittedLines.count)))
        }
    }

    private func join(_ lines: [String]) -> String {
        Utils.join(lines.joined(separator: "\n"))
    }

    private func split(_ text: String, spacingString: String) -> [String] {
        Utils
            .split(text, spacing: spacingString)
            .split(separator: "\n")
            .compactMap({ String($0) })
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
}
