//
//  ToDoTests.swift
//  ToDoTests
//
//
import CoreData

import XCTest
import SwiftUI
@testable import ToDo

class MyProjectTests: XCTestCase {
    
    func testStyleForPriority() {
        let contentView = ContentView()
        
        XCTAssertEqual(contentView.styleForPriority(Priority.low.rawValue), Color.yellow)
        XCTAssertEqual(contentView.styleForPriority(Priority.medium.rawValue), Color.orange)
        XCTAssertEqual(contentView.styleForPriority(Priority.high.rawValue), Color.red)
        XCTAssertEqual(contentView.styleForPriority(""), Color.black)
        XCTAssertEqual(contentView.styleForPriority("invalid"), Color.black)
    }
}

class MyAppTests: XCTestCase {
    
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        try super.setUpWithError()

        // Create an in-memory Core Data store for testing
        let container = NSPersistentContainer(name: "MyApp")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Failed to load test store: \(error)")
            }
        }
        managedObjectContext = container.viewContext
    }
    
    override func tearDownWithError() throws {
        // Clean up after each test
        managedObjectContext = nil
        try super.tearDownWithError()
    }
    
    func testSaveTask() throws {
        // Given
        let sut = ContentView()
        sut.title = "New task"
        sut.selectedPriority = .high
//        sut.viewContext = managedObjectContext

        // When
        sut.saveTask()

        // Then
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let tasks = try managedObjectContext.fetch(fetchRequest)

        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks.first?.title, "New task")
        XCTAssertEqual(tasks.first?.priority, Priority.high.rawValue)
    }
}
