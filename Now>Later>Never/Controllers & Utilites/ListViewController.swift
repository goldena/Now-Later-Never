//
//  ToDoListViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 9.01.21.
//

import UIKit

class ListViewController: UIViewController {

    var tasks: [Task] = []
    var listType: ListType!
}
  
// MARK: - Extension - Persistent Storage Interface
extension ListViewController {
    
    func createTask(_ task: Task, on listType: ListType) {
        
        switch persistentStorage.createTask(task, on: listType) {
        case .success(_):
            return
        case .failure(let storageError):
            print("\(storageError)")
            return
        }
    }
    
    func readTasks(from listType: ListType) -> [Task] {
        
        switch persistentStorage.readTasks(from: listType) {
        case .success(let tasks):
            return tasks
        case .failure(let storageError):
            print("\(storageError)")
            return []
        }
    }
    
    func updateTask(at index: Int, with task: Task, to list: ListType) {
        
        switch persistentStorage.updateTask(at: index, with: task, on: listType) {
        case .success(let task):
            tasks[index] = task
        case .failure(let storageError):
            print("\(storageError)")
        }
    }
    
    func deleteTask(at index: Int, from list: ListType) -> Task? {
        
        switch persistentStorage.deleteTask(at: index, from: listType) {
        case .success(let task):
            tasks.remove(at: index)
            return task
            
        case .failure(let storageError):
            print("\(storageError)")
            return nil
        }
    }
    
    func moveTask(at index: Int, to listType: ListType) {
        
        guard let task = deleteTask(at: index, from: listType) else {
            return
        }
        
        persistentStorage.createTask(task, on: listType)
    }
}
