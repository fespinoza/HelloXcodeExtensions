//
//  Utils.swift
//  SplitJoin
//
//  Created by Felipe Espinoza on 19/11/2019.
//  Copyright © 2019 Felipe Espinoza. All rights reserved.
//

import Foundation

struct Utils {
    static func split(_ string: String) -> String {
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
                                .joined(separator: ",\n\(spacing)    ")

                            returnString += "(\n    \(spacing)\(newContent)\n\(spacing))"
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

    static func join(_ string: String) -> String {
        var foo = string.replacingOccurrences(of: "\n", with: "")

        foo = foo.replacingOccurrences(of: #",\s+"#, with: ", ", options: .regularExpression)
        foo = foo.replacingOccurrences(of: #"\(\s+"#, with: "(", options: .regularExpression)
        foo = foo.replacingOccurrences(of: #"\s+\)"#, with: ")", options: .regularExpression)

        return foo
    }
}
