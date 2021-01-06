//
//  ToDoRecord.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 3.01.21.
//

import Foundation

enum Category {
    case Personal
    case Work
    case Education
}

struct ToDoRecord {
    var title: String
    var category: Category
    var date: Date
    var isDone: Bool
}
