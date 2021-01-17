//
//  ToDoRecord.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 3.01.21.
//

import Foundation

enum Category: String {
    case Personal
    case Work
    case Education
}

enum ListType: String {
    case Today
    case Later
    case Never
    case Done
}

struct Task {
    var title: String
    var category: Category
    var date: Date
}
