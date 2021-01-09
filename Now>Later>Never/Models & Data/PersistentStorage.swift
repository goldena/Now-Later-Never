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
    static private var nowList =
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
    
    static private var tomorrowList: [ToDoRecord]   = []
    static private var neverList: [ToDoRecord]      = []
    static private var doneList: [ToDoRecord]       = []

    static func createToDoRecord(_ record: ToDoRecord,
                                 on list: List) -> Result<Bool, StorageErrors> {
        switch list {
        case .Now:
            nowList.append(record)
        case .Tomorrow:
            tomorrowList.append(record)
        case .Never:
            neverList.append(record)
        case .Done:
            doneList.append(record)
        }
        
        return .success(true)
    }
    
    static func readToDoRecords(from list: List) -> Result<[ToDoRecord], StorageErrors> {
        switch list {
        case .Now:
            return .success(nowList)
        case .Tomorrow:
            return .success(tomorrowList)
        case .Never:
            return .success(neverList)
        case .Done:
            return .success(doneList)
        }
    }

    static func updateToDoRecord(at index: Int,
                                 with record: ToDoRecord,
                                 on list: List) -> Result<Bool, StorageErrors> {
        if index >= 0 && index < nowList.count {
            switch list {
            case .Now:
                nowList[index] = record
            case .Tomorrow:
                tomorrowList[index] = record
            case .Never:
                neverList[index] = record
            case .Done:
                doneList[index] = record
            }
            return .success(true)
        } else {
            return .failure(.UnableToUpdateRecordError)
        }
    }
    
    static func deleteToDoRecord(at index: Int,
                                 on list: List) -> Result<ToDoRecord, StorageErrors> {
        if index >= 0 && index < nowList.count {
            switch list {
            case .Now:
                return .success(nowList.remove(at: index))
            case .Tomorrow:
                return .success(tomorrowList.remove(at: index))
            case .Never:
                return .success(neverList.remove(at: index))
            case .Done:
                return .success(doneList.remove(at: index))
            }
        } else {
            return .failure(.UnableToDeleteRecordError)
        }
    }
}
