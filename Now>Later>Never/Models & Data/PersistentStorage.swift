//
//  PersistentStorage.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 3.01.21.
//

import Foundation
import CloudKit

enum NetworkErrors: Error {
    case NoConnectionError
    case AuthentificationError
}

enum StorageErrors: Error {
    case UnableToDeleteRecordError
    case UnableToCreateRecordError
    case UnableToUpdateRecordError
    case UnableToRetreveRecordsError
}

class PersistentStorage {
    // Temporary stub
    static private var toDoRecords =
        [ToDoRecord(title: "test1", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test2", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test3", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test4", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test5", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test6", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test7", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test8", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test9", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test10", category: .Personal, date: Date(), isDone: false),
        ]
    
    static func createToDoRecord(_ record: ToDoRecord) -> Result<Bool, StorageErrors> {
        toDoRecords.append(record)
        return .success(true)
    }
    
    static func readToDoRecords() -> Result<[ToDoRecord], StorageErrors> {
        return .success(toDoRecords)
    }

    static func updateToDoRecord(at index: Int, with record: ToDoRecord) -> Result<Bool, StorageErrors> {
        if index >= 0 && index < toDoRecords.count {
            toDoRecords[index] = record
            return .success(true)
        } else {
            return .failure(.UnableToUpdateRecordError)
        }
    }
    
    static func deleteToDoRecord(at index: Int) -> Result<ToDoRecord, StorageErrors> {
        if index >= 0 && index < toDoRecords.count {
            return .success(toDoRecords.remove(at: index))
        } else {
            return .failure(.UnableToDeleteRecordError)
        }
    }
}
