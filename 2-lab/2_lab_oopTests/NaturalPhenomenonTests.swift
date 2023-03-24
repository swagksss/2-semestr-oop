//
//  NaturalPhenomenonTests.swift
//  2_lab_oopTests
//
//

import XCTest
@testable import __lab_oop

class NaturalPhenomenonTests: XCTestCase {
    func testBaseNaturalPhenomenon() {
        let naturalPhenomenon = BaseNaturalPhenomenon()
        XCTAssertEqual(naturalPhenomenon.display(), "This is a natural phenomenon.")
        XCTAssertEqual(naturalPhenomenon.simulate(), "")
    }

    func testDecorator() {
        let naturalPhenomenon = BaseNaturalPhenomenon()
        let decorator = Decorator(wrapped: naturalPhenomenon)
        XCTAssertEqual(decorator.display(), "This is a natural phenomenon.")
        XCTAssertEqual(decorator.simulate(), "")
    }

    func testWeatherDecorator() {
        let naturalPhenomenon = BaseNaturalPhenomenon()
        let decorator = WeatherDecorator(wrapped: naturalPhenomenon)
        XCTAssertTrue(decorator.display().contains("weather"))
        XCTAssertNotEqual(decorator.simulate(), "")
    }

    func testEarthquake() {
        let earthquake = Earthquake()
        XCTAssertTrue(earthquake.display().contains("earthquake"))
        XCTAssertNotEqual(earthquake.simulate(), "")
    }

    func testTsunami() {
        let tsunami = Tsunami()
        XCTAssertTrue(tsunami.display().contains("tsunami"))
        XCTAssertNotEqual(tsunami.simulate(), "")
    }

    func testThunderstorm() {
        let thunderstorm = Thunderstorm()
        XCTAssertTrue(thunderstorm.display().contains("thunderstorm"))
        XCTAssertNotEqual(thunderstorm.simulate(), "")
    }

    func testHurricane() {
        let hurricane = Hurricane()
        XCTAssertTrue(hurricane.display().contains("hurricane"))
        XCTAssertNotEqual(hurricane.simulate(), "")
    }
}
