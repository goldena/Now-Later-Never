//
//  ViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 3.01.21.
//

import UIKit

class ListViewController: UIViewController, PersistentStorageCRUD {
    
    // MARK: - Properties
    private var listType: ListType
    private var tasks: [Task] = []
    private var taskTableView: UITableView!
    
    // MARK: - Class Init
    init(listType: ListType) {
        self.listType = listType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods - View Lifecycle
    override func loadView() {
        taskTableView = UITableView()
        view = taskTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTableView.rowHeight = 100
        
        taskTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: Const.TaskReusableCellID)
        taskTableView.dataSource = self
        taskTableView.delegate = self
        
        persistentStorage.todayListDelegate = self
        
        tasks = readTasks(from: listType)        
    }
}

// MARK: - Extensions
extension ListViewController: PersistentStorageListDelegate {
    
    func didUpdateList() {
        tasks = readTasks(from: listType)
        taskTableView.reloadData()
    }
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = taskTableView.dequeueReusableCell(
            withIdentifier: Const.TaskReusableCellID,
            for: indexPath
        ) as? TaskTableViewCell else {
            fatalError("Could not downcast a UITableViewCell to the Custom Cell")
        }
        
        let task = tasks[indexPath.row]
        
        cell.taskTitleLabel.text = task.title
        
        if task.done {
            cell.toggleCheckmark()
        }
        
        // Show or hide task description depending on if it is nil or not
        if task.description != nil {
            cell.taskDescriptionLabel.text = task.description
            cell.taskDescriptionLabel.isHidden = false
        } else {
            cell.taskDescriptionLabel.isHidden = true
        }
        
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    
    // Leading swipe action
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var action: UIContextualAction
        
        switch listType {
        case .Today:
            let title = NSLocalizedString("Later", comment: "Move the task to the Later Tab")
            
            action = UIContextualAction(style: .normal, title: title, handler: { (action, view, completionHandler) in
                self.moveTask(from: self.listType, at: indexPath.row, to: .Later)
                self.tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                completionHandler(true)
            })
            
            action.image = UIImage(systemName: "arrow.right", withConfiguration: Const.LargeSFSymbol)
            action.backgroundColor = .systemGreen

        case .Later:
            let title = NSLocalizedString("Today", comment: "Move the task to the Today Tab")
            
            action = UIContextualAction(style: .normal, title: title, handler: { (action, view, completionHandler) in
                
                self.moveTask(from: self.listType, at: indexPath.row, to: .Today)
                self.tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                completionHandler(true)
            })
 
            action.image = UIImage(systemName: "list.bullet", withConfiguration: Const.LargeSFSymbol)
            action.backgroundColor = .systemGreen

        case .Done:
            let title = NSLocalizedString("Restore", comment: "Move the task to the Today Tab")
            
            action = UIContextualAction(style: .normal, title: title, handler: { (action, view, completionHandler) in
                
                self.moveTask(from: self.listType, at: indexPath.row, to: .Today)
                self.tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                completionHandler(true)
            })
 
            action.image = UIImage(systemName: "list.bullet", withConfiguration: Const.LargeSFSymbol)
            action.backgroundColor = .systemGreen

        case .Never:
            let title = NSLocalizedString("Restore", comment: "Move the task to the Today Tab")
            
            action = UIContextualAction(style: .normal, title: title, handler: { (action, view, completionHandler) in
                
                self.moveTask(from: self.listType, at: indexPath.row, to: .Today)
                self.tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                completionHandler(true)
            })
            
            action.image = UIImage(systemName: "list.bullet", withConfiguration: Const.LargeSFSymbol)
            action.backgroundColor = .systemGreen
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    // Trailing swipe action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var action: UIContextualAction
        
        switch listType {
        case .Today:
        let title = NSLocalizedString("Never", comment: "Move the Task to the Never Tab")
        
        action = UIContextualAction(
            style: .destructive,
            title: title,
            handler: { (action, view,completionHandler)
                in
                self.moveTask(from: self.listType, at: indexPath.row, to: .Never)
                self.tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                completionHandler(true)
            })
        
        action.image = UIImage(systemName: "xmark", withConfiguration: Const.LargeSFSymbol)
        action.backgroundColor = .systemRed
        
        case .Later:
        let title = NSLocalizedString("Never", comment: "Move the Task to the Never Tab")
        
        action = UIContextualAction(style: .destructive, title: title, handler: { (action, view, completionHandler) in
            
            self.moveTask(from: self.listType, at: indexPath.row, to: .Never)
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        })
        
        //action.image = UIImage(named: "heart")
        action.backgroundColor = .systemRed
                
        case .Done:
        let title = NSLocalizedString("Delete", comment: "Delete permanently")

        action = UIContextualAction(style: .destructive, title: title, handler: { (action, view, completionHandler) in
            
            self.deleteTask(from: self.listType, at: indexPath.row)
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        })
        
        case .Never:
        let title = NSLocalizedString("Delete", comment: "Delete Permanently")

            action = UIContextualAction(
            style: .destructive,
            title: title,
            handler: { (action, view, completionHandler) in
                self.deleteTask(from: self.listType, at: indexPath.row)
                self.tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                completionHandler(true)
        })

        //action.image = UIImage(named: "heart")
        action.backgroundColor = .systemRed
        }
        
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            fatalError("Invalid cell selection")
        }
        
        // Deselect row after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            // Check is selected row still exists
            guard let _ = tableView.cellForRow(at: indexPath) else { return }
            tableView.deselectRow(at: indexPath, animated: true)
        })
        
        // Toggle checkmark
        cell.toggleCheckmark()
        
        // Update Data Source
        tasks[indexPath.row].done.toggle()
    }
}
