//
//  GameViewControllerTests.swift
//  Swift CheckersTests
//
//

import XCTest
@testable import Swift_Checkers
class GameViewControllerTests: XCTestCase {

    func testViewDidLoad() {
        let gameVC = GameViewController()
        gameVC.loadViewIfNeeded()
        
        // Check that the scene was created and added to the SKView
        XCTAssertNotNil(gameVC.view)
        XCTAssertTrue(gameVC.view is SKView)
        let skView = gameVC.view as! SKView
        XCTAssertNotNil(skView.scene)
        XCTAssertTrue(skView.scene is GameScene)
    }

    func testShouldAutorotate() {
        let gameVC = GameViewController()
        XCTAssertTrue(gameVC.shouldAutorotate)
    }

    func testSupportedInterfaceOrientations() {
        let gameVC = GameViewController()
        if UIDevice.current.userInterfaceIdiom == .phone {
            XCTAssertEqual(gameVC.supportedInterfaceOrientations, .allButUpsideDown)
        } else {
            XCTAssertEqual(gameVC.supportedInterfaceOrientations, .all)
        }
    }

    func testPrefersStatusBarHidden() {
        let gameVC = GameViewController()
        XCTAssertTrue(gameVC.prefersStatusBarHidden)
    }
    
    static var allTests = [        ("testViewDidLoad", testViewDidLoad),        ("testShouldAutorotate", testShouldAutorotate),        ("testSupportedInterfaceOrientations", testSupportedInterfaceOrientations),        ("testPrefersStatusBarHidden", testPrefersStatusBarHidden),    ]
}
