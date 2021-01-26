//
//  ViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 3.01.21.
//

import UIKit

class TodayListViewController: UIViewController, PersistentStorageCRUD {
    
    // MARK: - Properties
    private var listType: ListType = .Today
    private var tasks: [Task] = []

    @IBOutlet private weak var TaskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TaskTableView.dataSource = self
        TaskTableView.delegate = self
        
        persistentStorage.todayListDelegate = self
        
        tasks = readTasks(from: listType)
    }
}

// MARK: - Extensions
extension TodayListViewController: PersistentStorageTodayListDelegate {

    func didUpdateList() {
        tasks = readTasks(from: listType)
        TaskTableView.reloadData()
    }
}

extension TodayListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = TaskTableView.dequeueReusableCell(
                withIdentifier: Const.TaskReusableCellID,
                for: indexPath
        ) as? TaskTableViewCell else {
            fatalError("Could not downcast a UITableViewCell to the Custom Cell")
        }

        if tasks[indexPath.row].done == false {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        
        cell.TaskLabel.text = tasks[indexPath.row].title
        return cell
    }
}

extension TodayListViewController: UITableViewDelegate {
    
    // Leading swipe action
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let title = NSLocalizedString("Later", comment: "Move the task to the Later Tab")

        let action = UIContextualAction(style: .normal, title: title, handler: { (action, view, completionHandler) in
            
            self.moveTask(from: self.listType, at: indexPath.row, to: .Later)
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        })

        //action.image = UIImage(named: "heart")
        action.backgroundColor = .systemGreen

        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    // Trailing swipe action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let title = NSLocalizedString("Never", comment: "Move the Task to the Never Tab")

        let action = UIContextualAction(style: .destructive, title: title, handler: { (action, view,completionHandler) in
            
            self.moveTask(from: self.listType, at: indexPath.row, to: .Never)
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        })
        
        //action.image = UIImage(named: "heart")
        action.backgroundColor = .systemRed

        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            fatalError("Invalid cell selection")
        }

        // Deselect cell after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
            cell.isSelected = false
        }
        
        // Toggle checkmark
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        
        // Change Data Source
        tasks[indexPath.row].done.toggle()
        
    }
}
