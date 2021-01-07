import Foundation

extension String {
    /// An easier way to define a regular expression and get the first match of that expression in `self`
    /// - Parameter pattern: a string describing a regular expression pattern
    func firstMatch(with pattern: String) -> NSTextCheckingResult? {
        let stringRange = NSRange(startIndex..<endIndex, in: self)

        guard
            let regexp = try? NSRegularExpression(pattern: pattern, options: []),
            let match = regexp.firstMatch(in: self, options: [], range: stringRange)
        else {
            return nil
        }

        return match
    }

    /// Get a named capture group from a match in a given string
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

    /// Get a tuple with the first character of the string and the rest of string
    func splitInFirstAndRest() -> (first: String, rest: String) {
        let first = String(self[startIndex])

        let newStartIndex = String.Index(utf16Offset: 1, in: self)
        let stringRange = Range<String.Index>(uncheckedBounds: (lower: newStartIndex, upper: endIndex))
        let rest = String(self[stringRange])

        return (first: first, rest: rest)
    }
}
