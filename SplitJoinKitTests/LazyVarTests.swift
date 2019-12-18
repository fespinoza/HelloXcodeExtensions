//
//  LazyVarTests.swift
//  SplitJoinKitTests
//
//  Created by Felipe Espinoza on 16/12/2019.
//  Copyright © 2019 Felipe Espinoza. All rights reserved.
//

import XCTest
import SplitJoinKit

class LazyVarTests: XCTestCase {
    /*
     - other test cases
        - private
        - classes with UI in the middle of the name
        - joinable assignments?


     - multiple line cases?

     */
    let normalConstantText = "let someTextField = UITextField(withAutoLayout: true)"

    let lazyVarText = """
    lazy var someTextField: UITextField = {
        let textField = UITextField(withAutoLayout: true)
        return textField
    }()
    """

    var lazyVarLines: [String] {
        lazyVarText.split(separator: "\n").compactMap({ String($0) })
    }

    func testConvertingToLazyVar() {
        let result = toLazyVar(line: normalConstantText)
        XCTAssertEqual(result, lazyVarText)
    }

    func testCovnertingToNormalConstant() {
        let result = toNormalConstant(lines: lazyVarLines)
        XCTAssertEqual(result, normalConstantText)
    }

    private func toLazyVar(line: String, spacing: String = "    ") -> String {
        Utils.toLazyVar(line: line, spacing: spacing)
    }

    private func toNormalConstant(lines: [String]) -> String? {
        Utils.toNormalConstant(lines: lines)
    }
}
