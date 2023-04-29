//
//  test.swift
//  Swift CheckersTests
//
//

import XCTest
@testable import Swift_Checkers

class GameSceneTests: XCTestCase {
    var gameScene: GameScene!

    override func setUpWithError() throws {
        gameScene = GameScene()
    }

    override func tearDownWithError() throws {
        gameScene = nil
    }

    func testIsValidIndex() throws {
        XCTAssertTrue(gameScene.isValidIndex(index: 0))
        XCTAssertFalse(gameScene.isValidIndex(index: 1))
        XCTAssertTrue(gameScene.isValidIndex(index: 2))
        XCTAssertFalse(gameScene.isValidIndex(index: 3))
        XCTAssertTrue(gameScene.isValidIndex(index: 4))
        XCTAssertFalse(gameScene.isValidIndex(index: 5))
        XCTAssertTrue(gameScene.isValidIndex(index: 6))
        XCTAssertFalse(gameScene.isValidIndex(index: 7))
        XCTAssertTrue(gameScene.isValidIndex(index: 8))
        XCTAssertFalse(gameScene.isValidIndex(index: 9))
        XCTAssertTrue(gameScene.isValidIndex(index: 10))
        XCTAssertFalse(gameScene.isValidIndex(index: 11))
        XCTAssertTrue(gameScene.isValidIndex(index: 12))
        XCTAssertFalse(gameScene.isValidIndex(index: 13))
        XCTAssertTrue(gameScene.isValidIndex(index: 14))
        XCTAssertFalse(gameScene.isValidIndex(index: 15))
    }
}
