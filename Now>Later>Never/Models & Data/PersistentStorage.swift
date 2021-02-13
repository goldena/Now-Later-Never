//
//  PersistentStorage.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 3.01.21.
//

import UIKit
// import CloudKit
import CoreData

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
protocol PersistentStorageListDelegate {
    func didUpdateList()
}

final class PersistentStorage {
    // Core Data Persistent Storage
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Properties - Delegates
    var todayListDelegate: PersistentStorageListDelegate?
    var laterListDelegate: PersistentStorageListDelegate?
    var doneListDelegate: PersistentStorageListDelegate?
    var neverListDelegate: PersistentStorageListDelegate?
    
    // MARK: - Properties - Temporary data stub
        
    private var todayList: [Task] = []
    private var laterList: [Task] = []
    private var doneList: [Task] = []
    private var neverList: [Task] = []

    // MARK: - Methods
    func addTask(_ task: Task, to list: ListType) -> Result<Bool, StorageErrors> {

        let managedTask = ManagedTask(context: context)
        
        managedTask.title = task.title
        managedTask.listType = list.rawValue
        managedTask.category = task.category.rawValue
        managedTask.optionalDescription = task.optionalDescription
        managedTask.date = task.date
        managedTask.done = task.done

        do {
            try context.save()
        } catch {
            print("Error while saving the items \(error)")
        }
        
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
                
        return .success(true)
    }
    
    func readTasks(from list: ListType) -> Result<[Task], StorageErrors> {
        let request: NSFetchRequest<ManagedTask> = ManagedTask.fetchRequest()
        var managedTasks: [ManagedTask]
        
        do {
            managedTasks = try context.fetch(request)
            print(managedTasks)
        } catch {
            fatalError("Error fetching data from the context \(error)")
        }
        
        for managedTask in managedTasks {
            let task = Task(
                title: managedTask.title!,
                optionalDescription: managedTask.description,
                category: Category.init(rawValue: managedTask.category!)!,
                date: managedTask.date!,
                done: managedTask.done
            )
            
            switch ListType.init(rawValue: managedTask.listType!) {
            case .Today:
                todayList.append(task)
            case .Later:
                laterList.append(task)
            case .Done:
                doneList.append(task)
            case .Never:
                neverList.append(task)
            default:
                fatalError("Unknown list type encountered.")
            }
        }
        
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
