//
//  ToDoTests.swift
//  ToDoTests
//
//
import XCTest
import SwiftUI
import CoreData
@testable import ToDo

class TaskPriorityTests: XCTestCase {

    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Insert a test task with low priority into the Core Data store
        let newTask = Task(context: context)
        newTask.title = "Test Task"
        newTask.priority = Priority.low.rawValue
        newTask.dateCreated = Date()
        newTask.isFavorite = false
        try context.save()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Remove the test task from the Core Data store
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Task.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
        try context.save()
    }
    
    func testPriority() throws {
        // Test the title and color of each priority level
        XCTAssertEqual(Priority.low.title, "Low")
        XCTAssertEqual(Priority.medium.title, "Medium")
        XCTAssertEqual(Priority.high.title, "High")
        XCTAssertEqual(Priority.low.color, Color.yellow)
        XCTAssertEqual(Priority.medium.color, Color.orange)
        XCTAssertEqual(Priority.high.color, Color.red)
    }
    
    func testTaskPriorityColor() throws {
        // Test that the priorityColor computed property returns the correct color for each task
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let tasks = try context.fetch(fetchRequest)
        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks.first?.priorityColor, Color.yellow)
    }
    
    
    func testUpdateTask() throws {
        // Test updating a task in the Core Data store
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let tasks = try context.fetch(fetchRequest)
        XCTAssertEqual(tasks.count, 1)
        let task = tasks.first!
        task.isFavorite = true
        try context.save()
        let updatedTasks = try context.fetch(fetchRequest)
        XCTAssertEqual(updatedTasks.count, 1)
        XCTAssertEqual(updatedTasks.first?.isFavorite, true)
    }
    
    func testDeleteTask() throws {
        // Test deleting a task from the Core Data store
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let tasks = try context.fetch(fetchRequest)
        XCTAssertEqual(tasks.count, 1)
        let task = tasks.first!
        context.delete(task)
        try context.save()
        let remainingTasks = try context.fetch(fetchRequest)
        XCTAssertEqual(remainingTasks.count, 0)
    }
}
