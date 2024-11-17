//
//  ToDoDetailScreen.swift
//  SwiftUI_ToDoApp_SwiftData
//
//  Created by Eren Elçi on 18.11.2024.
//

import SwiftUI

struct ToDoDetailScreen: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name : String = ""
    @State private var priority : Int?
    
    let toDo : ToDo
    
    var body: some View {
        Form {
            TextField(text: $name) {
                Text("Name")
            }
            TextField(value: $priority, format: .number) {
                Text("Priority")
            }
            Button {
                guard let priority = priority else { return }
                toDo.name = name
                toDo.priority = priority
                do{
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
                dismiss()
                
            } label: {
                Text("Update")
            }.onAppear {
                name = toDo.name
                priority = toDo.priority
            }
        }
        

    }
}
/*
#Preview {
    ToDoDetailScreen()
}
*/
