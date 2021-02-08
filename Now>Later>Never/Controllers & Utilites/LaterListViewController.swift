//
//  LaterListViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 9.01.21.
//

import UIKit

class LaterListViewController: UIViewController, PersistentStorageCRUD {
    
    // MARK: - Properties
    private var listType: ListType = .Later
    private var tasks: [Task] = []
    
    @IBOutlet private weak var TaskTableView: UITableView!
    
    // MARK: - View Controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TaskTableView.dataSource = self
        TaskTableView.delegate = self
        persistentStorage.laterListDelegate = self
        
        tasks = readTasks(from: listType)
    }
}
    
// MARK: - Extensions
extension LaterListViewController: PersistentStorageListDelegate {
    
    func didUpdateList() {
        tasks = readTasks(from: listType)
        TaskTableView.reloadData()
    }
}

extension LaterListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = TaskTableView.dequeueReusableCell(withIdentifier: Const.TaskReusableCellID, for: indexPath) as? TaskTableViewCell else {
            fatalError("Could not downcast a UITableViewCell to the Custom Cell")
        }

        cell.taskTitleLabel.text = tasks[indexPath.row].title
        return cell
    }
}

extension LaterListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let title = NSLocalizedString("Today", comment: "Move to Today Tab")

        let action = UIContextualAction(style: .normal, title: title, handler: { (action, view, completionHandler) in
                                            
            self.moveTask(from: self.listType, at: indexPath.row, to: .Today)
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
                                        })

        //action.image = UIImage(named: "heart")
        action.backgroundColor = .systemGreen

        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let title = NSLocalizedString("Never", comment: "Move the Task to the Never Tab")

        let action = UIContextualAction(style: .destructive, title: title, handler: { (action, view, completionHandler) in
                                            
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

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
//    }
}
