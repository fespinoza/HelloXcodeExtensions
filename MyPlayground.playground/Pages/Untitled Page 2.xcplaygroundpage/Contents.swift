//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

let range = Range.init(NSRange(location: 7, length: 10), in: str)!

str[range] ?? ""


str.replaceSubrange(range, with: "World")

str


var str2 = "titleFont: .caption, titleColor: .textPrimary, titleNumberOfLines: 1"

var str3 = str2.replacingOccurrences(of: ", ", with: "%", options: [], range: nil).split(separator: "%").joined(separator: ",\n\t")

print(str3)
