//
//  ViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 3.01.21.
//

import UIKit

class ToDosViewController: UIViewController {
        
    @IBOutlet private weak var ToDosTableView: UITableView!
    
    private let toDoCellID = "ToDoReusableCellID"

    private var toDoRecords = PersistentStorage.loadToDoRecords()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ToDosTableView.dataSource   = self
        ToDosTableView.delegate     = self
    }
}

extension ToDosViewController: UITableViewDataSource {
    
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
        
        toDoCell.ToDoLabel.text = toDoRecords[indexPath.row].record
        return toDoCell
    }
}

extension ToDosViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let title = NSLocalizedString("Not today",
                                      comment: "Move to Tomorrow ToDos")

        let action = UIContextualAction(style: .normal,
                                        title: title,
                                        handler: { (action,
                                                    view,
                                                    completionHandler) in
                                            // Update data source when user taps action
                                            // self.dataSource?.setFavorite(!favorite, at: indexPath)
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
                                            // Update data source when user taps action
                                            // self.dataSource?.setFavorite(!favorite, at: indexPath)
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
