//
//  ToDoListViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 9.01.21.
//

import UIKit

class ToDoListViewController: UIViewController {

    // MARK: - Properties    
    var toDoRecords: [ToDoRecord] = []
    var list: ListType!
    
    // MARK: - Methods
    func createToDoRecord(_ record: ToDoRecord) {
        
        switch PersistentStorage.createToDoRecord(record, on: list) {
        case .success(_):
            return
        case .failure(let storageError):
            print("\(storageError)")
            return
        }
    }
    
    func readToDoRecords() -> [ToDoRecord] {
        
        switch PersistentStorage.readToDoRecords(from: list) {
        case .success(let toDoRecords):
            return toDoRecords
        case .failure(let storageError):
            print("\(storageError)")
            return []
        }
    }
    
    func updateToDoRecords(at index: Int, with record: ToDoRecord) {
        
        switch PersistentStorage.updateToDoRecord(at: index, with: record, on: list) {
        case .success(_):
            return
        case .failure(let storageError):
            print("\(storageError)")
            return
        }
    }
    
    func deleteToDoRecord(at index: Int) {
        
        switch PersistentStorage.deleteToDoRecord(at: index, on: list) {
        case .success(_):
            toDoRecords = readToDoRecords()
        case .failure(let storageError):
            print("\(storageError)")
        }
    }
}
