//
//  PersistentStorageCRUD.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 24.01.21.
//

import Foundation

protocol PersistentStorageCRUD {
    
    func addTask(_ task: Task, to list: ListType)
    
    func readTasks(from list: ListType) -> [Task]
    
    func updateTask(_ task: Task, at index: Int, on list: ListType)
    
    func deleteTask(from list: ListType, at index: Int) -> Task?
    
    func moveTask(from list: ListType,at index: Int, to toList: ListType)
}

extension PersistentStorageCRUD {
    
    func addTask(_ task: Task, to list: ListType) {
        switch persistentStorage.addTask(task, to: list) {
        
        case .success(_):
            return
            
        case .failure(let storageError):
            print("\(storageError)")
            return
        }
    }
    
    func readTasks(from list: ListType) -> [Task] {
        switch persistentStorage.readTasks(from: list) {
        
        case .success(let tasks):
            return tasks
            
        case .failure(let storageError):
            print("\(storageError)")
            return []
        }
    }
    
    func updateTask(_ task: Task, at index: Int, on list: ListType) {
        switch persistentStorage.updateTask(on: list, at: index, with: task) {
        
        case .success(_):
            return
            
        case .failure(let storageError):
            print("\(storageError)")
        }
    }
    
    func deleteTask(from list: ListType, at index: Int) -> Task? {
        switch persistentStorage.deleteTask(at: index, from: list) {
        
        case .success(let task):
            return task
            
        case .failure(let storageError):
            print("\(storageError)")
            return nil
        }
    }
    
    func moveTask(from list: ListType, at index: Int, to toList: ListType) {
        guard let task = deleteTask(from: list, at: index) else {
            return
        }
        
        persistentStorage.addTask(task, to: toList)
    }
}
