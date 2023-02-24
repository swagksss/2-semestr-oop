//
//  CoreDataManager.swift
//  ToDo
//
//Менеджер основних даних - відповідає за налаштування нашого стеку основних даних
import Foundation
import CoreData

//Дані диспетчера даних - єдиний спосіб створити диспетчеросновних даних, використовуючи загальну властивість і створити тільки один єдиний екземляр
class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    static let shared: CoreDataManager = CoreDataManager()
    
    //Ініціалізатор встановлений як приватний, щоб не можна було створювати кілька екземплярів основного диспетчера даних
    private init() {
        
        persistentContainer = NSPersistentContainer(name: "ToDo") //постійний контейнер- завантажує постійні сховища и настраює весь стек
        persistentContainer.loadPersistentStores { description, error in // завантажте сховище та получемо опис сховища
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")// виводимо помилку якщо є помилка при створенні нашого загального диспетчера даних
            }
        }
        
    }
    
}
