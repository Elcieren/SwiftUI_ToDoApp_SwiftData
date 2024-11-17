//
//  SwiftUI_ToDoApp_SwiftDataApp.swift
//  SwiftUI_ToDoApp_SwiftData
//
//  Created by Eren Elçi on 18.11.2024.
//

import SwiftUI

@main
struct SwiftUI_ToDoApp_SwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ListScreen()
            }
            
        }.modelContainer(for: [ToDo.self])
    }
}
