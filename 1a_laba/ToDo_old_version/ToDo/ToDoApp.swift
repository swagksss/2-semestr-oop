//
//  TodoApp.swift
//  ToDo
//
//
import SwiftUI

@main
struct SimpleTodoApp: App {
    
    let persistentContainer = CoreDataManager.shared.persistentContainer //доступ до постійного контейнера за допомогою основного диспетчера даних
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistentContainer.viewContext) // можемо отримати доступ до контексту управління об'єктом зсередини
        }
    }
}
