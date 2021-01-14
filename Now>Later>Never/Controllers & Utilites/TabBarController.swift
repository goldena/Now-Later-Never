//
//  TabBarControllerViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 14.01.21.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    // MARK: - Properties
    private var todayListViewController:    ToDoListViewController!
    private var laterListViewController:    ToDoListViewController!
    private var doneListViewController:     ToDoListViewController!
    private var neverListViewController:    ToDoListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    func prepareViewControllers() {
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        
        guard let toDoListViewController = viewController as? ToDoListViewController else {
            fatalError("Could not downcast a viewController to a custom one")
        }
        
        toDoListViewController.updateUI()
        return true
    }

}
