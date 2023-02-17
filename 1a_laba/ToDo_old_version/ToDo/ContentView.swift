//
//  ContentView.swift
//  ToDo
//
//
import SwiftUI
//створюємо перелік для подання пріоритетів
enum Priority: String, Identifiable, CaseIterable {
    
    var id: UUID {
        return UUID()
    }
    
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}
//створюємо додаткову властивість розширення перерахування пріоритетів
extension Priority {
    
    var title: String {
        switch self {
            case .low:
                return "Low"
            case .medium:
                return "Medium"
            case .high:
                return "High"
        }
    }
}


struct ContentView: View {
    
    @State public var title: String = ""
    @State public var selectedPriority: Priority = .medium
    @Environment(\.managedObjectContext) public var viewContext
    
    //Створюємо властивість запиту - це означає, що ми можемо виконувати ці запити на вибірку прямо
    //Створити екземпляр дескриптора та передати ключ: дата створення
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) private var allTasks: FetchedResults<Task> //рядок у якому ви повинні виконувати завдання вибірки результатів задачі
    
    public func saveTask() {
        
        do {
            let task = Task(context: viewContext)
            task.title = title
            task.priority = selectedPriority.rawValue
            task.dateCreated = Date()
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
     public func styleForPriority(_ value: String) -> Color {
        let priority = Priority(rawValue: value)
        
        switch priority {
            case .low:
                return Color.yellow
            case .medium:
                return Color.orange
            case .high:
                return Color.red
            default:
                return Color.black
        }
    }
    
    public func updateTask(_ task: Task) {
        
        task.isFavorite = !task.isFavorite
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func deleteTask(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = allTasks[index]
            viewContext.delete(task)
            
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
     //Вигляд головної сторінки навігації
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter title", text: $title)
                    .textFieldStyle(.roundedBorder)
                Picker("Priority", selection: $selectedPriority) {
                    ForEach(Priority.allCases) { priority in
                        Text(priority.title).tag(priority)
                    }
                }.pickerStyle(.segmented)
                
                Button("Save") {
                    saveTask()
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
// Відображаємо список завдань
                List {
                    
                    ForEach(allTasks) { task in
                        HStack {
                            Circle()
                                .fill(styleForPriority(task.priority!))
                                .frame(width: 15, height: 15)
                            Spacer().frame(width: 20)
                            Text(task.title ?? "")
                            Spacer()
                            Image(systemName: task.isFavorite ? "heart.fill": "heart")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    updateTask(task)
                                }
                        }
                    }.onDelete(perform: deleteTask)
                    
                }
                
                
                Spacer()
            }
            .padding()
            .navigationTitle("All Tasks")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistedContainer = CoreDataManager.shared.persistentContainer
        ContentView().environment(\.managedObjectContext, persistedContainer.viewContext)
    }
}
