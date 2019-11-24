import Cocoa

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

print("it works")

//regexp = /(?<left>[^(]*)\((?<content>.*)\)(?<right>.*)/
func matches(string: String) throws -> String {
//    let pattern = #"(?<preContent>[^(]+)\((?<content>[^)])\)(?<suffix>.*)"#
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
                        .joined(separator: ",\n\(spacing)\t")

                    returnString += "(\n\t\(spacing)\(newContent)\n\(spacing))"
                } else {
                    returnString += String(string[range])
                }
            }
        }
    }

    return returnString
}


let result = try? matches(string: joined)
print(result ?? "Nothing")
