//
//  PersistentStorage.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 3.01.21.
//

import UIKit
import CoreData

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

protocol PersistentStorageListDelegate {
    func didUpdateList()
}

final class PersistentStorage {
    // Core Data Persistent Storage
    static private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static private var managedTaskArray: [ManagedTask] = []
    
    // MARK: - Properties - Delegates
    
    static var todayListDelegate: PersistentStorageListDelegate?
    static var laterListDelegate: PersistentStorageListDelegate?
    static var doneListDelegate: PersistentStorageListDelegate?
    static var neverListDelegate: PersistentStorageListDelegate?
            
    // MARK: - Methods
    
    static func addTask(_ task: Task, to list: ListType) -> Result<ObjectIdentifier, StorageErrors> {

        let managedTask = ManagedTask(context: context)
        
        managedTask.title = task.title
        managedTask.listType = list.rawValue
        managedTask.category = task.category.rawValue
        managedTask.optionalDescription = task.optionalDescription
        managedTask.date = task.date
        managedTask.done = task.done
        
        saveContext()
        updateListUsingDelegate(list)
        
        return .success(managedTask.id)
    }
    
    static func readTasks(from list: ListType) -> Result<[Task], StorageErrors> {
        let request: NSFetchRequest<ManagedTask> = ManagedTask.fetchRequest()
        var taskArray: [Task] = []
        
        do {
            managedTaskArray = try context.fetch(request)
        } catch {
            fatalError("Error fetching data from the context \(error)")
        }
        
        let filteredManagedTaskArray = managedTaskArray.filter { (managedTask) -> Bool in
            ListType.init(rawValue: managedTask.listType!) == list
        }
        
        #warning("Refactor")
        for managedTask in filteredManagedTaskArray {
            let task = Task(
                title: managedTask.title!,
                optionalDescription: managedTask.optionalDescription,
                category: Category.init(rawValue: managedTask.category!)!,
                date: managedTask.date!,
                done: managedTask.done,
                id: managedTask.id
            )
            
            taskArray.append(task)
        }

        return .success(taskArray)
    }

    static func updateTask(on list: ListType, withID id: ObjectIdentifier, with task: Task) -> Result<ObjectIdentifier, StorageErrors> {

        guard let index = managedTaskArray.firstIndex(where: { (managedTask) -> Bool in
            managedTask.id == id
        }) else {
            fatalError("Could not find an object with the specified ID")
        }

        let updatedManagedTask = managedTaskArray[index]
        
        updatedManagedTask.title = task.title
        updatedManagedTask.listType = list.rawValue
        updatedManagedTask.category = task.category.rawValue
        updatedManagedTask.optionalDescription = task.optionalDescription
        // updatedManagedTask.date = task.date
        updatedManagedTask.done = task.done

        saveContext()
        
        // updateListUsingDelegate(list)
        
        return .success(id)
        
    }
    
    static func deleteTask(withID id: ObjectIdentifier, from list: ListType) -> Result<ObjectIdentifier, StorageErrors> {

        guard let index = managedTaskArray.firstIndex(where: { (managedTask) -> Bool in
            managedTask.id == id
        }) else {
            fatalError("Could not find an object with the specified ID")
        }
        
        context.delete(managedTaskArray[index])
        managedTaskArray.remove(at: index)
        saveContext()
 
        return .success(id)
    }
    
    static func moveTask(withID id: ObjectIdentifier, to toList: ListType) -> Result<ObjectIdentifier, StorageErrors> {
        guard let index = managedTaskArray.firstIndex(where: { (managedTask) -> Bool in
            managedTask.id == id
        }) else {
            fatalError("Could not find an object with the specified ID")
        }

        managedTaskArray[index].listType = toList.rawValue
        saveContext()
        updateListUsingDelegate(toList)
        
        return .success(id)
    }
    
    private static func updateListUsingDelegate(_ list: ListType) {
        switch list {
        case .Today:
            todayListDelegate?.didUpdateList()
            
        case .Later:
            laterListDelegate?.didUpdateList()
            
        case .Never:
            neverListDelegate?.didUpdateList()
            
        case .Done:
            doneListDelegate?.didUpdateList()
        }
    }
    
    private static func saveContext() {
        do {
            try context.save()
        } catch {
            fatalError("Error while saving the items \(error)")
        }
    }
}
