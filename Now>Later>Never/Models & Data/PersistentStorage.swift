//
//  PersistentStorage.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 3.01.21.
//

import Foundation
import CloudKit

// MARK: - Persistent Storage - Singleton
var persistentStorage = PersistentStorage()

// MARK: - Enums - Errors
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

// MARK: - Protocols - Delegation
protocol PersistentStorageTodayListDelegate {
    func didUpdateList()
}

protocol PersistentStorageLaterListDelegate {
    func didUpdateList()
}

protocol PersistentStorageDoneListDelegate {
    func didUpdateList()
}

protocol PersistentStorageNeverListDelegate {
    func didUpdateList()
}

final class PersistentStorage {
    // MARK: - Properties - Delegates
    var todayListDelegate:  PersistentStorageTodayListDelegate?
    var laterListDelegate:  PersistentStorageLaterListDelegate?
    var doneListDelegate:   PersistentStorageDoneListDelegate?
    var neverListDelegate:  PersistentStorageNeverListDelegate?
    
    // MARK: - Properties - Temporary data stub
    private var todayList =
        [Task(title: "test1", description: "test1", category: .Personal, date: Date(), done: false),
         Task(title: "test2", category: .Personal, date: Date(), done: false),
         Task(title: "test3", category: .Personal, date: Date(), done: false),
         Task(title: "test4", category: .Personal, date: Date(), done: false),
         Task(title: "test5", category: .Personal, date: Date(), done: false),
         Task(title: "test6", category: .Personal, date: Date(), done: false),
         Task(title: "test7", category: .Personal, date: Date(), done: false),
         Task(title: "test8", category: .Personal, date: Date(), done: false),
         Task(title: "test9", category: .Personal, date: Date(), done: false),
         Task(title: "test10", category: .Personal, date: Date(), done: false),
        ]
    
    private var laterList =
        [Task(title: "test11", category: .Personal, date: Date(), done: false),
         Task(title: "test12", category: .Personal, date: Date(), done: false),
         Task(title: "test13", category: .Personal, date: Date(), done: false),
         Task(title: "test14", category: .Personal, date: Date(), done: false),
         Task(title: "test15", category: .Personal, date: Date(), done: false),
         Task(title: "test16", category: .Personal, date: Date(), done: false),
         Task(title: "test17", category: .Personal, date: Date(), done: false),
         Task(title: "test18", category: .Personal, date: Date(), done: false),
         Task(title: "test19", category: .Personal, date: Date(), done: false),
         Task(title: "test20", category: .Personal, date: Date(), done: false),
        ]

    private var doneList =
        [Task(title: "test21", category: .Personal, date: Date(), done: false),
         Task(title: "test22", category: .Personal, date: Date(), done: false),
         Task(title: "test23", category: .Personal, date: Date(), done: false),
         Task(title: "test24", category: .Personal, date: Date(), done: false),
         Task(title: "test25", category: .Personal, date: Date(), done: false),
         Task(title: "test26", category: .Personal, date: Date(), done: false),
         Task(title: "test27", category: .Personal, date: Date(), done: false),
         Task(title: "test28", category: .Personal, date: Date(), done: false),
         Task(title: "test29", category: .Personal, date: Date(), done: false),
         Task(title: "test30", category: .Personal, date: Date(), done: false),
        ]

    private var neverList =
        [Task(title: "test31", category: .Personal, date: Date(), done: false),
         Task(title: "test32", category: .Personal, date: Date(), done: false),
         Task(title: "test33", category: .Personal, date: Date(), done: false),
         Task(title: "test34", category: .Personal, date: Date(), done: false),
         Task(title: "test35", category: .Personal, date: Date(), done: false),
         Task(title: "test36", category: .Personal, date: Date(), done: false),
         Task(title: "test37", category: .Personal, date: Date(), done: false),
         Task(title: "test38", category: .Personal, date: Date(), done: false),
         Task(title: "test39", category: .Personal, date: Date(), done: false),
         Task(title: "test40", category: .Personal, date: Date(), done: false),
        ]

    // MARK: - Methods
    func addTask(_ task: Task, to list: ListType) -> Result<Bool, StorageErrors> {
        switch list {
        case .Today:
            todayList.append(task)
            todayListDelegate?.didUpdateList()
            
        case .Later:
            laterList.append(task)
            laterListDelegate?.didUpdateList()
            
        case .Never:
            neverList.append(task)
            neverListDelegate?.didUpdateList()
            
        case .Done:
            doneList.append(task)
            doneListDelegate?.didUpdateList()
        }
        
        return .success(true)
    }
    
    func readTasks(from list: ListType) -> Result<[Task], StorageErrors> {
        switch list {
        case .Today:
            return .success(todayList)
            
        case .Later:
            return .success(laterList)
            
        case .Never:
            return .success(neverList)
            
        case .Done:
            return .success(doneList)
        }
    }

    func updateTask(on list: ListType, at index: Int, with task: Task) -> Result<Task, StorageErrors> {
        guard isInBounds(of: list, for: index) else {
            return .failure(.UnableToUpdateRecordError)
        }
        
        switch list {
        case .Today:
            todayList[index] = task
            // todayListDelegate?.didUpdateList()
        
        case .Later:
            laterList[index] = task
            // laterListDelegate?.didUpdateList()
        
        case .Never:
            neverList[index] = task
            // neverListDelegate?.didUpdateList()
        
        case .Done:
            doneList[index] = task
            // doneListDelegate?.didUpdateList()
        }
        
        return .success(task)
        
    }

    func deleteTask(at index: Int, from list: ListType) -> Result<Task, StorageErrors> {
        guard isInBounds(of: list, for: index) else {
            return .failure(.UnableToDeleteRecordError)
        }
        
        switch list {
        case .Today:
            // todayListDelegate?.didUpdateList()
            return .success(todayList.remove(at: index))
            
        case .Later:
            // laterListDelegate?.didUpdateList()
            return .success(laterList.remove(at: index))
            
        case .Never:
            // neverListDelegate?.didUpdateList()
            return .success(neverList.remove(at: index))
            
        case .Done:
            // doneListDelegate?.didUpdateList()
            return .success(doneList.remove(at: index))
        }
    }
     
    // MARK: - Private Methods
    private func isInBounds(of list: ListType, for index: Int) -> Bool {
        guard index >= 0 else {
            return false
        }
        
        switch list {
        case .Today:
            return index < todayList.count
            
        case .Later:
            return index < laterList.count
            
        case .Never:
            return index < neverList.count
            
        case .Done:
            return index < doneList.count
        }
    }
}
