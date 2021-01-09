//
//  LaterListViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 9.01.21.
//

import UIKit

class LaterListViewController: ToDoListViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var ToDosTableView: UITableView!

    private let toDoCellID = "ToDoReusableCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ToDosTableView.dataSource   = self
        ToDosTableView.delegate     = self

        list = .Later
        toDoRecords = readToDoRecords()
    }
    
    private func updateUI() {
        ToDosTableView.reloadData()
    }
}
    
// MARK: - Extensions
extension LaterListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return toDoRecords.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let toDoCell = ToDosTableView.dequeueReusableCell(withIdentifier: toDoCellID,
                                                                for: indexPath) as? ToDoTableViewCell else {
            fatalError("Could not downcast a UITableViewCell to the Custom Cell")
        }

        toDoCell.ToDoLabel.text = toDoRecords[indexPath.row].title
        return toDoCell
    }
}

extension LaterListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let title = NSLocalizedString("Not today",
                                      comment: "Move to Tomorrow ToDos")

        let action = UIContextualAction(style: .normal,
                                        title: title,
                                        handler: { (action,
                                                    view,
                                                    completionHandler) in
                                            self.deleteToDoRecord(at: indexPath.row)
                                            self.updateUI()
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
                                      comment: "Delete")

        let action = UIContextualAction(style: .destructive,
                                        title: title,
                                        handler: { (action,
                                                    view,
                                                    completionHandler) in
                                            self.deleteToDoRecord(at: indexPath.row)
                                            self.updateUI()
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
