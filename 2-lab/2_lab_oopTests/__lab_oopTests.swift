//
//  __lab_oopTests.swift
//  2_lab_oopTests
//
//

//import XCTest
//@testable import __lab_oop
//
//class NaturalPhenomenonTests: XCTestCase {
//    
//    func testEarthquake() {
//        let earthquake = Earthquake()
//        let displayVisitor = DisplayVisitor(displayText: .constant(""))
//        earthquake.accept(visitor: displayVisitor)
//        XCTAssertEqual(displayVisitor.displayText, "This is an earthquake.\n")
//        
//        let simulateVisitor = SimulateVisitor(displayText: .constant(""))
//        earthquake.accept(visitor: simulateVisitor)
//        XCTAssertTrue(simulateVisitor.displayText.contains("The magnitude of the earthquake is "))
//    }
//    
//    func testTsunami() {
//        let tsunami = Tsunami()
//        let displayVisitor = DisplayVisitor(displayText: .constant(""))
//        tsunami.accept(visitor: displayVisitor)
//        XCTAssertEqual(displayVisitor.displayText, "This is a tsunami.\n")
//        
//        let simulateVisitor = SimulateVisitor(displayText: .constant(""))
//        tsunami.accept(visitor: simulateVisitor)
//        XCTAssertTrue(simulateVisitor.displayText.contains("The height of the tsunami is "))
//    }
//    
//    func testThunderstorm() {
//        let thunderstorm = Thunderstorm()
//        let displayVisitor = DisplayVisitor(displayText: .constant(""))
//        thunderstorm.accept(visitor: displayVisitor)
//        XCTAssertEqual(displayVisitor.displayText, "This is a thunderstorm.\n")
//        
//        let simulateVisitor = SimulateVisitor(displayText: .constant(""))
//        thunderstorm.accept(visitor: simulateVisitor)
//        XCTAssertTrue(simulateVisitor.displayText.contains("There were "))
//    }
//    
//    func testHurricane() {
//        let hurricane = Hurricane()
//        let displayVisitor = DisplayVisitor(displayText: .constant(""))
//        hurricane.accept(visitor: displayVisitor)
//        XCTAssertEqual(displayVisitor.displayText, "This is a hurricane.\n")
//        
//        let simulateVisitor = SimulateVisitor(displayText: .constant(""))
//        hurricane.accept(visitor: simulateVisitor)
//        XCTAssertTrue(simulateVisitor.displayText.contains("The wind speed of the hurricane is "))
//    }
//    
//    func testWeatherDecorator() {
//        let earthquake = Earthquake()
//        let weatherDecorator = WeatherDecorator(wrapped: earthquake)
//        let displayVisitor = DisplayVisitor(displayText: .constant(""))
//        weatherDecorator.accept(visitor: displayVisitor)
//        XCTAssertTrue(displayVisitor.displayText.contains("This is an earthquake. This natural phenomenon is related to the weather.\n"))
//        
//        let simulateVisitor = SimulateVisitor(displayText: .constant(""))
//        weatherDecorator.accept(visitor: simulateVisitor)
//        XCTAssertTrue(simulateVisitor.displayText.contains("The temperature is "))
//    }
//}
