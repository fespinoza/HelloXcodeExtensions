//
//  SplitJoinKitTests.swift
//  SplitJoinKitTests
//
//  Created by Felipe Espinoza on 26/11/2019.
//  Copyright © 2019 Felipe Espinoza. All rights reserved.
//

import XCTest
import SplitJoinKit

class SplitJoinKitTests: XCTestCase {
    private func split(_ string: String) -> String {
        Utils.split(string)
    }

    private func join(_ string: String) -> String {
        Utils.join(string)
    }

    // TODO: test nested cases

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

    func testSplitIdentity() {
        XCTAssertEqual(split(splitted), splitted)
    }

    func testSplit() {
        XCTAssertEqual(split(joined), splitted)
    }

    func testJoin() {
        XCTAssertEqual(join(splitted), joined)
    }

    func testJoinIdentity() {
        XCTAssertEqual(join(joined), joined)
    }
}
