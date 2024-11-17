//
//  ToDo.swift
//  SwiftUI_ToDoApp_SwiftData
//
//  Created by Eren Elçi on 18.11.2024.
//

import Foundation
import SwiftData

@Model
final class ToDo {
    var name: String
    var priority : Int
    
    init(name: String, priority: Int) {
        self.name = name
        self.priority = priority
    }
}
