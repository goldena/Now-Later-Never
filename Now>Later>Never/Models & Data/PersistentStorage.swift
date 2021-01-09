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
    
    static private var laterList =
        [ToDoRecord(title: "test11", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test12", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test13", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test14", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test15", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test16", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test17", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test18", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test19", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test20", category: .Personal, date: Date(), isDone: false),
        ]

    static private var neverList: [ToDoRecord] =
        [ToDoRecord(title: "test21", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test22", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test23", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test24", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test25", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test26", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test27", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test28", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test29", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test30", category: .Personal, date: Date(), isDone: false),
        ]

    static private var doneList: [ToDoRecord] =
        [ToDoRecord(title: "test31", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test32", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test33", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test34", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test35", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test36", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test37", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test38", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test39", category: .Personal, date: Date(), isDone: false),
         ToDoRecord(title: "test40", category: .Personal, date: Date(), isDone: false),
        ]

    // MARK: - Methods
    static func createToDoRecord(_ record: ToDoRecord,
                                 on list: ListType) -> Result<ToDoRecord, StorageErrors> {
        
        switch list {
        case .Now:
            nowList.append(record)
        case .Later:
            laterList.append(record)
        case .Never:
            neverList.append(record)
        case .Done:
            doneList.append(record)
        }
        
        return .success(record)
    }
    
    static func readToDoRecords(from list: ListType) -> Result<[ToDoRecord], StorageErrors> {
        
        switch list {
        case .Now:
            return .success(nowList)
        case .Later:
            return .success(laterList)
        case .Never:
            return .success(neverList)
        case .Done:
            return .success(doneList)
        }
    }

    static func updateToDoRecord(at index: Int,
                                 with record: ToDoRecord,
                                 on list: ListType) -> Result<ToDoRecord, StorageErrors> {
        
        guard checkBounds(of: list, for: index) else {
            return .failure(.UnableToUpdateRecordError)
        }
        
        switch list {
        case .Now:
            nowList[index] = record
        case .Later:
            laterList[index] = record
        case .Never:
            neverList[index] = record
        case .Done:
            doneList[index] = record
        }
        
        return .success(record)
    }
    
    static func deleteToDoRecord(at index: Int,
                                 on list: ListType) -> Result<ToDoRecord, StorageErrors> {

        guard checkBounds(of: list, for: index) else {
            return .failure(.UnableToDeleteRecordError)
        }
        
        switch list {
        case .Now:
            return .success(nowList.remove(at: index))
        case .Later:
            return .success(laterList.remove(at: index))
        case .Never:
            return .success(neverList.remove(at: index))
        case .Done:
            return .success(doneList.remove(at: index))
        }
    }
        
    private static func checkBounds(of list: ListType, for index: Int) -> Bool {

        guard index >= 0 else {
            return false
        }
        
        switch list {
        case .Now:
            return index < nowList.count
        case .Later:
            return index < laterList.count
        case .Never:
            return index < neverList.count
        case .Done:
            return index < doneList.count
        }
    }
}
