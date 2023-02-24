//
//  ContentView.swift
//  ToDo
//
//

import SwiftUI
import CoreData

enum Priority: String, Identifiable, CaseIterable {
    
    var id: UUID {
        return UUID()
    }
    
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var title: String {
        return self.rawValue
    }
    
    var color: Color {
        switch self {
        case .low:
            return Color.yellow
        case .medium:
            return Color.orange
        case .high:
            return Color.red
        }
    }
}
extension Task {
    var priorityColor: Color {
        guard let priorityString = priority, let priority = Priority(rawValue: priorityString) else {
            return Color.black
        }
        
        switch priority {
        case .low:
            return Color.yellow
        case .medium:
            return Color.orange
        case .high:
            return Color.red
        }
    }
}

struct TaskView: View {
    let task: Task
    
    var body: some View {
        HStack {
            Circle()
                .fill(task.priorityColor)
                .frame(width: 15, height: 15)
            Spacer().frame(width: 20)
            Text(task.title ?? "")
            Spacer()
            Image(systemName: task.isFavorite ? "heart.fill": "heart")
                .foregroundColor(.red)
        }
    }
}
   
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Task.dateCreated, ascending: false)])
    private var tasks: FetchedResults<Task>

    @State private var title: String = ""
    @State private var selectedPriority: Priority = .medium
    
    
    private func addTask() {
        withAnimation {
            let newTask = Task(context: viewContext)
            newTask.title = title
            newTask.priority = selectedPriority.rawValue
            newTask.dateCreated = Date()
            newTask.isFavorite = false
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        title = ""
        selectedPriority = .medium
    }
    
    private func updateTask(_ task: Task) {
        withAnimation {
            task.isFavorite.toggle()
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func deleteTask(_ task: Task) {
        withAnimation {
            viewContext.delete(task)
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
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
                
                Button(action: addTask) {
                    Text("Save")
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                
                List {
                                    ForEach(tasks) { task in
                                        TaskView(task: task)
                                            .foregroundColor(task.isFavorite ? .red : .primary)
                                            .onTapGesture {
                                                updateTask(task)
                                            }
                                    }
                                    .onDelete(perform: { indexSet in
                                        indexSet.forEach { index in
                                            deleteTask(tasks[index])
                                        }
                                    })
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
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let newTask = Task(context: context)
        newTask.title = "Example Task"
        newTask.priority = Priority.low.rawValue // Set the priority using the rawValue of the Priority enum
        return ContentView().environment(\.managedObjectContext, context)
    }
}

