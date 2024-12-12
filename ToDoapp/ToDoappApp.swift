//
//  ToDoappApp.swift
//  ToDoapp
//
//  Created by Ayumu Urakami on 2024/12/12.
//

import SwiftUI

@main
struct ToDoappApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
