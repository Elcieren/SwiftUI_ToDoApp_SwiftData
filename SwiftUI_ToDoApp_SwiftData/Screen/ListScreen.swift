//
//  ListScreen.swift
//  SwiftUI_ToDoApp_SwiftData
//
//  Created by Eren Elçi on 18.11.2024.
//

import SwiftUI
import SwiftData

struct ListScreen: View {
    @Query(sort: \ToDo.name, order: .forward) private var toDos: [ToDo]
    @State private var isAddToDoPresented : Bool = false
    
    
    var body: some View {
       
        ToDoListView(toDos: toDos)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAddToDoPresented = true
                    } label: {
                        Text("Add ToDo")
                    }

                }
            }
            .sheet(isPresented: $isAddToDoPresented) {
                NavigationStack{
                    AddToDoScreen()
                }
            }
        
    }
}

#Preview {
    NavigationStack {
        ListScreen().modelContainer(for: [ToDo.self])
    }
    
}
