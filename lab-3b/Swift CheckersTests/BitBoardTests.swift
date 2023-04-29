//
//  ControllerTests.swift
//  Swift CheckersTests
//
//

import XCTest
@testable import Swift_Checkers


final class BitBoardTests: XCTestCase {
    
    func testInit() {
        let bitBoard = BitBoard()
        XCTAssertEqual(bitBoard.white, 0x00000FFF)
        XCTAssertEqual(bitBoard.black, 0xFFF00000)
        XCTAssertEqual(bitBoard.queen, 0)
        XCTAssertEqual(bitBoard.player, false)
        XCTAssertEqual(bitBoard.range, 0..<256)
    }
    
    func testInitWithInvalidInput() {
        XCTAssertFatalError {
            _ = BitBoard(white: 0b1010, black: 0b0101, queen: 0, player: false)
        }
        XCTAssertFatalError {
            _ = BitBoard(white: 0b1000, black: 0b0001, queen: 0b0010, player: false)
        }
    }
    
    func testMaskIndexInit() {
        let mask = BitBoard.Mask(maskIndex: 10)
        XCTAssertEqual(mask, 0b1_0000_0000)
    }
    
    func testMaskDescription() {
        let mask = BitBoard.Mask(maskIndex: 10)
        XCTAssertEqual(mask.description, "●○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○○")
    }
    
    func testHasIndex() {
        let mask = BitBoard.Mask(maskIndex: 10)
        XCTAssertTrue(mask.hasIndex(maskIndex: 10))
        XCTAssertFalse(mask.hasIndex(maskIndex: 0))
    }
    
    func testIndexSet() {
        let mask = BitBoard.Mask(maskIndex: 10)
        XCTAssertEqual(mask.indexSet(), [10])
    }
    
    func testCheckSet() {
        let mask = BitBoard.Mask(maskIndex: 10)
        XCTAssertEqual(mask.checkSet(), [20])
    }
    
    func testCheckIndexInit() {
        let checkIndex = BitBoard.CheckIndex(20)
        XCTAssertEqual(checkIndex, 10)
    }
    
    func testMakeIterator() {
        let bitBoard = BitBoard()
        let iterator = bitBoard.makeIterator()
        var count = 0
        for _ in iterator {
            count += 1
        }
        XCTAssertEqual(count, 256)
    }
    
    static var allTests = [
        ("testInit", testInit),
        ("testInitWithInvalidInput", testInitWithInvalidInput),
        ("testMaskIndexInit", testMaskIndexInit),
        ("testMaskDescription", testMaskDescription),
        ("testHasIndex", testHasIndex),
        ("testIndexSet", testIndexSet),
        ("testCheckSet", testCheckSet),
        ("testCheckIndexInit", testCheckIndexInit),
        ("testMakeIterator", testMakeIterator),
    ]
}

extension XCTestCase {
    func XCTAssertFatalError(file: StaticString = #file, line: UInt = #line, block: () -> Void) {
        var assertionThrown = false
        let exceptionHandler: @convention(thin) (NSException) -> Void = { _ in assertionThrown = true }
        // Set an exception handler, which will catch the fatalError() call
        // and prevent theprogram from crashing
        let oldExceptionHandler = NSGetUncaughtExceptionHandler()
        NSSetUncaughtExceptionHandler(exceptionHandler)
        // Call the block, which should trigger a fatalError() call
        block()
        
        // Remove the exception handler
        NSSetUncaughtExceptionHandler(oldExceptionHandler)
        
        // If no assertion was thrown, fail the test
        if !assertionThrown {
            XCTFail("Expected a fatal error", file: file, line: line)
        }
    }
}
