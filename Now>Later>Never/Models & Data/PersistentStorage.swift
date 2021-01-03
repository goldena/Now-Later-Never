//
//  PersistentStorage.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 3.01.21.
//

import Foundation
import CloudKit

enum SaveErrors: Error {
    case NetworkError
    case AuthentificationError
    case DataSaveError
}

class PersistentStorage {
    // Temporary stub
    static private var toDoRecords =
        [ToDoRecord(record: "test1", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(record: "test2", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(record: "test3", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(record: "test4", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(record: "test5", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(record: "test6", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(record: "test7", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(record: "test8", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(record: "test9", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(record: "test10", category: .Personal, date: Date(), isDone: false),
        ]
    
    static func saveToDoRecord(_ record: ToDoRecord) -> Result<Bool, Error> {
        toDoRecords.append(record)
        return .success(true)
    }

    static func loadToDoRecords() -> [ToDoRecord] {
        return toDoRecords
    }
}
