//
//  ViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 3.01.21.
//

import UIKit

class TodayListViewController: ToDoListViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var ToDosTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ToDosTableView.dataSource   = self
        ToDosTableView.delegate     = self

        list = .Today
        toDoRecords = readToDoRecords()
    }
}
    
// MARK: - Extensions
extension TodayListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return toDoRecords.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = ToDosTableView.dequeueReusableCell(withIdentifier: toDoCellID,
                                                                for: indexPath) as? ToDoTableViewCell else {
            fatalError("Could not downcast a UITableViewCell to the Custom Cell")
        }

        cell.ToDoLabel.text = toDoRecords[indexPath.row].title
        return cell
    }
}

extension TodayListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let title = NSLocalizedString("Later",
                                      comment: "Move to Later Tab")

        let action = UIContextualAction(style: .normal,
                                        title: title,
                                        handler: { (action,
                                                    view,
                                                    completionHandler) in
                                            self.moveToDoRecord(at: indexPath.row,
                                                                to: .Later)
                                            tableView.deleteRows(at: [indexPath],
                                                                 with: .fade)
                                            completionHandler(true)
                                        })

        // Design:
        //action.image = UIImage(named: "heart")
        action.backgroundColor = .systemGreen

        // configuration.performsFirstActionWithFullSwipe = true
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let title = NSLocalizedString("Never",
                                      comment: "Move to Never Tab")

        let action = UIContextualAction(style: .destructive,
                                        title: title,
                                        handler: { (action,
                                                    view,
                                                    completionHandler) in
                                            self.moveToDoRecord(at: indexPath.row,
                                                                to: .Never)
                                            tableView.deleteRows(at: [indexPath],
                                                                 with: .fade)
                                            completionHandler(true)
                                        })

        // Design:
        //action.image = UIImage(named: "heart")
        action.backgroundColor = .systemRed

        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
    }
}
