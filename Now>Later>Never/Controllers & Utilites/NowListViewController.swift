//
//  ViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 3.01.21.
//

import UIKit

class NowListViewController: ToDoListViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var ToDosTableView: UITableView!

    private let toDoCellID = "ToDoReusableCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ToDosTableView.dataSource   = self
        ToDosTableView.delegate     = self

        list = .Now
        toDoRecords = readToDoRecords()
    }
    
//    private func updateUI() {
//        ToDosTableView.reloadData()
//    }
}
    
// MARK: - Extensions
extension NowListViewController: UITableViewDataSource {

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

extension NowListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let title = NSLocalizedString("Later",
                                      comment: "Move to Later Tab")

        let action = UIContextualAction(style: .normal,
                                        title: title,
                                        handler: { (action,
                                                    view,
                                                    completionHandler) in
                                            self.deleteToDoRecord(at: indexPath.row)
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
                                            self.deleteToDoRecord(at: indexPath.row)
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
