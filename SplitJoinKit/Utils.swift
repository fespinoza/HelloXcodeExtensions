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
