//
//  ContentView.swift
//  2_lab_oop
//
//

import SwiftUI

protocol NaturalPhenomenon {
    func display() -> String
    func accept(visitor: Visitor)
    func simulate() -> String
}

class BaseNaturalPhenomenon: NaturalPhenomenon {
    func display() -> String {
        return "This is a natural phenomenon."
    }

    func accept(visitor: Visitor) {
        visitor.visit(naturalPhenomenon: self)
    }

    func simulate() -> String {
        // do nothing, as there is no simulation for the base natural phenomenon
        return ""
    }
}

class Decorator: NaturalPhenomenon {
    var wrapped: NaturalPhenomenon

    init(wrapped: NaturalPhenomenon) {
        self.wrapped = wrapped
    }

    func display() -> String {
        return wrapped.display()
    }

    func accept(visitor: Visitor) {
        wrapped.accept(visitor: visitor)
    }

    func simulate() -> String {
        return wrapped.simulate()
    }
}

class WeatherDecorator: Decorator {
    override func display() -> String {
        return super.display() + " This natural phenomenon is related to the weather."
    }

    override func simulate() -> String {
        let temperature = Int.random(in: -20...40)
        return "The temperature is \(temperature) degrees Celsius. " + super.simulate()
    }
}

class Application {
    static let shared = Application()
    private init() {
        let randomNumber = Int(arc4random_uniform(10))
    }
}

protocol Visitor {
    func visit(naturalPhenomenon: NaturalPhenomenon)
}

class DisplayVisitor: Visitor {
    @Binding var displayText: String

    init(displayText: Binding<String>) {
        _displayText = displayText
    }

    func visit(naturalPhenomenon: NaturalPhenomenon) {
        displayText += naturalPhenomenon.display() + "\n"
    }
}

class SimulateVisitor: Visitor {
    @Binding var displayText: String

    init(displayText: Binding<String>) {
        _displayText = displayText
    }

    func visit(naturalPhenomenon: NaturalPhenomenon) {
        displayText += naturalPhenomenon.simulate() + "\n"
    }
}

class Earthquake: BaseNaturalPhenomenon {
    override func display() -> String {
        return "This is an earthquake."
    }

    override func simulate() -> String {
        let magnitude = Double(Int.random(in: 1...100)) / 10
        var result = "The magnitude of the earthquake is \(magnitude) on the Richter scale. "

        if magnitude < 3.0 {
            result += "This is a minor earthquake."
        } else if magnitude < 6.0 {
            result += "This is a moderate earthquake."
        } else {
            result += "This is a major earthquake."
        }

        return result
    }
}

class Tsunami: BaseNaturalPhenomenon {
    override func display() -> String {
        return "This is a tsunami."
    }

    override func simulate() -> String {
        let height = Int.random(in: 1...30)
        var result = "The height of the tsunami is \(height) meters. "

        if height < 5 {
            result += "This is a small tsunami."
        } else if height < 10 {
            result += "This is a medium-sized tsunami."
        } else {result += "This is a large tsunami."
        }
        return result
    }
}

class Thunderstorm: BaseNaturalPhenomenon {
override func display() -> String {
return "This is a thunderstorm."
}
    override func simulate() -> String {
        let lightningCount = Int.random(in: 1...10)
        return "There were \(lightningCount) lightning strikes during the thunderstorm. " + super.simulate()
    }
}

class Hurricane: BaseNaturalPhenomenon {
override func display() -> String {
return "This is a hurricane."
}
    override func simulate() -> String {
        let windSpeed = Int.random(in: 100...300)
        var result = "The wind speed of the hurricane is \(windSpeed) km/h. "

        if windSpeed < 150 {
            result += "This is a category 1 or 2 hurricane."
        } else if windSpeed < 200 {
            result += "This is a category 3 or 4 hurricane."
        } else {
            result += "This is a category 5 hurricane."
        }

        return result
    }
}

struct ContentView: View {
    @State private var displayText = ""

    var body: some View {
        VStack {
            Text(displayText)
            Button("Display natural phenomena") {
                displayText = ""
                let visitor = DisplayVisitor(displayText: $displayText)

                let earthquake = Earthquake()
                earthquake.accept(visitor: visitor)

                let tsunami = Tsunami()
                tsunami.accept(visitor: visitor)

                let thunderstorm = Thunderstorm()
                thunderstorm.accept(visitor: visitor)

                let hurricane = Hurricane()
                hurricane.accept(visitor: visitor)

                let weatherDecorator = WeatherDecorator(wrapped: earthquake)
                weatherDecorator.accept(visitor: visitor)

                let weatherDecorator2 = WeatherDecorator(wrapped: tsunami)
                weatherDecorator2.accept(visitor: visitor)

                let weatherDecorator3 = WeatherDecorator(wrapped: thunderstorm)
                weatherDecorator3.accept(visitor: visitor)

                let weatherDecorator4 = WeatherDecorator(wrapped: hurricane)
                weatherDecorator4.accept(visitor: visitor)
            }
            Button("Simulate earthquake") {
                displayText = ""
                let visitor = SimulateVisitor(displayText: $displayText)

                let earthquake = Earthquake()
                earthquake.accept(visitor: visitor)
            }
            Button("Simulate tsunami") {
                displayText = ""
                let visitor = SimulateVisitor(displayText: $displayText)

                let tsunami = Tsunami()
                tsunami.accept(visitor: visitor)
            }
            Button("Simulate thunderstorm") {
                displayText = ""
                let visitor = SimulateVisitor(displayText: $displayText)

                let thunderstorm = Thunderstorm()
                thunderstorm.accept(visitor: visitor)
            }
            Button("Simulate hurricane") {
                displayText = ""
                let visitor = SimulateVisitor(displayText: $displayText)

                let hurricane = Hurricane()
                hurricane.accept(visitor: visitor)
            }
            Button("Simulate earthquake with weather") {
                displayText = ""
                let visitor = SimulateVisitor(displayText: $displayText)

                let earthquake = Earthquake()
                let weatherDecorator = WeatherDecorator(wrapped: earthquake)
                weatherDecorator.accept(visitor: visitor)
            }
            Button("Simulate tsunami with weather") {
                displayText = ""
                let visitor = SimulateVisitor(displayText: $displayText)

                let tsunami = Tsunami()
                let weatherDecorator = WeatherDecorator(wrapped: tsunami)
                weatherDecorator.accept(visitor: visitor)
            }
            Button("Simulate thunderstorm with weather") {
                displayText = ""
                let visitor = SimulateVisitor(displayText: $displayText)

                let thunderstorm = Thunderstorm()
                let weatherDecorator = WeatherDecorator(wrapped: thunderstorm)
                weatherDecorator.accept(visitor: visitor)
            }
            Button("Simulate hurricane with weather") {
                displayText = ""
                let visitor = SimulateVisitor(displayText: $displayText)

                let hurricane = Hurricane()
                let weatherDecorator = WeatherDecorator(wrapped: hurricane)
                weatherDecorator.accept(visitor: visitor)
            }
        }
    }
}
