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
            if nameRange.location != NSNotFound, let range = Range(nameRange, in: string) {
                if name == "spacing" {
                    preLineSpacing = String(string[range])
                }

                if name == "content" {
                    let substring = string[range]
                    let newContent = String(substring)
                        .replacingOccurrences(of: ", ", with: "%", options: [], range: nil)
                        .split(separator: "%")
                        .joined(separator: ",\n\(preLineSpacing)\(spacing)")

                    returnString += "(\n\(preLineSpacing)\(spacing)\(newContent)\n\(preLineSpacing))"
                } else {
                    returnString += String(string[range])
                }
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
