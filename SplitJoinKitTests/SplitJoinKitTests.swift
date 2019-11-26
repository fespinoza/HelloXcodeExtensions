//
//  SplitJoinKitTests.swift
//  SplitJoinKitTests
//
//  Created by Felipe Espinoza on 26/11/2019.
//  Copyright © 2019 Felipe Espinoza. All rights reserved.
//

import XCTest
import SplitJoinKit

struct SplitJoinTestCase {
    let name: String
    let joined: String
    let splitted: String
    var spacing: String = "    "
}

class SplitJoinKitTests: XCTestCase {
    let cases: [SplitJoinTestCase] = [
        SplitJoinTestCase(
            name: "Intial test case",
            joined: """
                static let attributesStyle = SampleAttributeStyle(titleFont: .caption, titleColor: .textPrimary, titleNumberOfLines: 1, titleColomnFixedWidth: 130)
            """,
            splitted: """
                static let attributesStyle = SampleAttributeStyle(
                    titleFont: .caption,
                    titleColor: .textPrimary,
                    titleNumberOfLines: 1,
                    titleColomnFixedWidth: 130
                )
            """
        ),
        SplitJoinTestCase(
            name: "Simple test case with 2 spaces",
            joined: """
                static let attributesStyle = SampleAttributeStyle(titleFont: .caption, titleColor: .textPrimary, titleNumberOfLines: 1, titleColomnFixedWidth: 130)
            """,
            splitted: """
                static let attributesStyle = SampleAttributeStyle(
                  titleFont: .caption,
                  titleColor: .textPrimary,
                  titleNumberOfLines: 1,
                  titleColomnFixedWidth: 130
                )
            """,
            spacing: "  "
        ),
        SplitJoinTestCase(
            name: "Simple test case with Tabs",
            joined: """
                static let attributesStyle = SampleAttributeStyle(titleFont: .caption, titleColor: .textPrimary, titleNumberOfLines: 1, titleColomnFixedWidth: 130)
            """,
            splitted: """
                static let attributesStyle = SampleAttributeStyle(
                \ttitleFont: .caption,
                \ttitleColor: .textPrimary,
                \ttitleNumberOfLines: 1,
                \ttitleColomnFixedWidth: 130
                )
            """,
            spacing: "\t"
        )
    ]

    func testSplitIdentity() {
        cases.forEach { testCase in
            XCTAssertEqual(
                split(testCase.splitted, spacing: testCase.spacing),
                testCase.splitted,
                "\(testCase.name) failed"
            )
        }
    }

    func testSplit() {
        cases.forEach { testCase in
            XCTAssertEqual(
                split(testCase.joined, spacing: testCase.spacing),
                testCase.splitted,
                "\(testCase.name) failed"
            )
        }
    }

    func testJoin() {
        cases.forEach { testCase in
            XCTAssertEqual(join(testCase.splitted), testCase.joined, "\(testCase.name) failed")
        }
    }

    func testJoinIdentity() {
        cases.forEach { testCase in
            XCTAssertEqual(join(testCase.joined), testCase.joined, "\(testCase.name) failed")
        }
    }

    private func split(_ string: String, spacing: String) -> String {
        Utils.split(string, spacingString: spacing)
    }

    private func join(_ string: String) -> String {
        Utils.join(string)
    }
}
