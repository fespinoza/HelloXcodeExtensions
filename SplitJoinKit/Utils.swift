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

    public static func split(_ string: String, spacingString: String = "    ") -> String {
        do {
            let pattern = #"(?<spacing>\s*)(?<preContent>[^\(]*)\((?<content>.*)\)(?<suffix>[^\)]*)"#
            let regex = try NSRegularExpression(pattern: pattern, options: [])

            let stringRange = NSRange(string.startIndex..<string.endIndex, in: string)
            var returnString = ""
            var spacing = ""

            if let match = regex.firstMatch(in: string, options: [], range: stringRange) {
                for name in ["spacing", "preContent", "content", "suffix"] {

                    let nameRange = match.range(withName: name)
                    if nameRange.location != NSNotFound, let range = Range(nameRange, in: string) {
                        print("\(name): \(string[range])")

                        if name == "spacing" {
                            spacing = String(string[range])
                        }


                        if name == "content" {
                            let substring = string[range]
                            let newContent = String(substring)
                                .replacingOccurrences(of: ", ", with: "%", options: [], range: nil)
                                .split(separator: "%")
                                .joined(separator: ",\n\(spacing)\(spacingString)")

                            returnString += "(\n\(spacing)\(spacingString)\(newContent)\n\(spacing))"
                        } else {
                            returnString += String(string[range])
                        }
                    }
                }
            } else {
                return string
            }

            return returnString
        } catch {
            return string
        }
    }

    public static func join(_ string: String) -> String {
        string
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: #",\s+"#, with: ", ", options: .regularExpression)
            .replacingOccurrences(of: #"\(\s+"#, with: "(", options: .regularExpression)
            .replacingOccurrences(of: #"\s+\)"#, with: ")", options: .regularExpression)
    }
}
