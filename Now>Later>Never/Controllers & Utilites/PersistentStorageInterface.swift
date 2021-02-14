//
//  PersistentStorageCRUD.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 24.01.21.
//

import Foundation

protocol PersistentStorageInterface {
    
    func addTask(_ task: Task, to list: ListType) -> ObjectIdentifier?

    func readTasks(from list: ListType) -> [Task]
    
    func updateTask(_ task: Task, withID: ObjectIdentifier, on list: ListType)
    
    func deleteTask(from list: ListType, withID: ObjectIdentifier)
    
    func moveTask(withID: ObjectIdentifier, to toList: ListType)
}

extension PersistentStorageInterface {
    
    func addTask(_ task: Task, to list: ListType) -> ObjectIdentifier? {
        switch PersistentStorage.addTask(task, to: list) {
        
        case .success(let objectIdentifier):
            return objectIdentifier
            
        case .failure(let storageError):
            print("\(storageError)")
            return nil
        }
    }
    
    func readTasks(from list: ListType) -> [Task] {
        switch PersistentStorage.readTasks(from: list) {
        case .success(let tasks):
            return tasks
            
        case .failure(let storageError):
            print("\(storageError)")
            return []
        }
    }
    
    func updateTask(_ task: Task, withID id: ObjectIdentifier, on list: ListType) {
        switch PersistentStorage.updateTask(on: list, withID: id, with: task) {
        case .success(_):
            return
            
        case .failure(let storageError):
            print("\(storageError)")
        }
    }
    
    func deleteTask(from list: ListType, withID id: ObjectIdentifier) {
        switch PersistentStorage.deleteTask(withID: id, from: list) {
        case .success:
            return
            
        case .failure(let storageError):
            print("\(storageError)")
        }
    }
    
    func moveTask(withID id: ObjectIdentifier, to toList: ListType) {
        switch PersistentStorage.moveTask(withID: id, to: toList) {
        case .success:
            return
            
        case .failure(let storageError):
            print("\(storageError)")
        }
    }
}
