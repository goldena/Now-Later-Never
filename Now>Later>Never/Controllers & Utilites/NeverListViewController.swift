//
//  NeverViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 9.01.21.
//

import UIKit

class NeverListViewController: UIViewController, PersistentStorageCRUD {
    
    // MARK: - Properties
    private var listType: ListType = .Never
    private var tasks: [Task] = []
    
    @IBOutlet private weak var TaskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TaskTableView.dataSource   = self
        TaskTableView.delegate     = self

        persistentStorage.neverListDelegate = self
        
        tasks = readTasks(from: listType)
    }
}

// MARK: - Extensions
extension NeverListViewController: PersistentStorageNeverListDelegate {
    
    func didUpdateList() {
        tasks = readTasks(from: listType)
        TaskTableView.reloadData()
    }
}

extension NeverListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = TaskTableView.dequeueReusableCell(withIdentifier: Const.TaskReusableCellID, for: indexPath) as? TaskTableViewCell else {
            fatalError("Could not downcast a UITableViewCell to the Custom Cell")
        }
        cell.TaskLabel.text = tasks[indexPath.row].title
        
        return cell
    }
}

extension NeverListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let title = NSLocalizedString("Now", comment: "Move to Now Tab")

        let action = UIContextualAction(
            style: .normal,
            title: title,
            handler: { (action, view, completionHandler) in
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
        
        let title = NSLocalizedString("Delete", comment: "Delete Permanently")

        let action = UIContextualAction(
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

        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
//    }
}
