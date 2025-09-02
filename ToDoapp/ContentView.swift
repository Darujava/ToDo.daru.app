import SwiftUI

enum TaskStatus: String, CaseIterable, Identifiable {
    case task = "Task"
    case doing = "Doing"
    case done = "Done"

    var id: String { rawValue }
}

struct TaskItem: Identifiable {
    let id = UUID()
    var title: String
    var status: TaskStatus = .task
    var date: Date
}

struct ContentView: View {
    @State private var tasks: [TaskItem] = []
    @State private var newTaskTitle: String = ""
    @State private var selectedDate: Date = Date()

    private var tasksForSelectedDate: [TaskItem] {
        tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }

    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)

            HStack(alignment: .top, spacing: 16) {
                ForEach(TaskStatus.allCases) { status in
                    VStack {
                        Text(status.rawValue)
                            .font(.headline)
                        List {
                            ForEach(tasksForSelectedDate.filter { $0.status == status }) { item in
                                Text(item.title)
                                    .contextMenu {
                                        ForEach(TaskStatus.allCases) { target in
                                            if target != status {
                                                Button(target.rawValue) {
                                                    move(item, to: target)
                                                }
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            HStack {
                TextField("New Task", text: $newTaskTitle)
                    .textFieldStyle(.roundedBorder)
                Button("Add") {
                    addTask()
                }
                .disabled(newTaskTitle.isEmpty)
            }
            .padding()
        }
        .padding()
    }

    private func addTask() {
        let item = TaskItem(title: newTaskTitle, date: selectedDate)
        tasks.append(item)
        newTaskTitle = ""
    }

    private func move(_ item: TaskItem, to status: TaskStatus) {
        if let index = tasks.firstIndex(where: { $0.id == item.id }) {
            tasks[index].status = status
        }
    }
}

#Preview {
    ContentView()
}
