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

        var returnString = ""
        var preLineSpacing = ""

        for name in ["spacing", "preContent", "content", "suffix"] {
            let nameRange = match.range(withName: name)
            guard
                let range = Range(nameRange, in: string),
                nameRange.location != NSNotFound
            else {
                continue
            }

            let substring = String(string[range])

            if name == "spacing" {
                preLineSpacing = substring
            }

            if name == "content" {
                let newContent = substring
                    .replacingOccurrences(of: ", ", with: "%", options: [], range: nil)
                    .split(separator: "%")
                    .joined(separator: ",\n\(preLineSpacing)\(spacing)")

                returnString += "(\n\(preLineSpacing)\(spacing)\(newContent)\n\(preLineSpacing))"
            } else {
                returnString += substring
            }
        }

        return returnString
    }

    public static func join(_ string: String) -> String {
        string
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: #",\s+"#, with: ", ", options: .regularExpression)
            .replacingOccurrences(of: #"\(\s+"#, with: "(", options: .regularExpression)
            .replacingOccurrences(of: #"\s+\)"#, with: ")", options: .regularExpression)
    }
}
