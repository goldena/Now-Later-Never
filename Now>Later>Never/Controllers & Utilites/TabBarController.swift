//
//  TabBarControllerViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 14.01.21.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = configureViewControllers()
        delegate = self
    }
         
    func configureViewControllers() -> [UIViewController] {
        var configuredViewControllers: [UIViewController] = []
                
        let todayListViewController = ListViewController(listType: .Today)
        todayListViewController.tabBarItem = UITabBarItem(
            title: "Today",
            image: UIImage(systemName: "list.bullet", withConfiguration: Const.LargeSFSymbol),
            tag: 0)
        configuredViewControllers.append(todayListViewController)
        
        let laterListViewController = ListViewController(listType: .Later)
        laterListViewController.tabBarItem = UITabBarItem(
            title: "Later",
            image: UIImage(systemName: "arrow.right", withConfiguration: Const.LargeSFSymbol),
            tag: 1)
        configuredViewControllers.append(laterListViewController)

        // TODO: Consider refactoring
        let dummyAddTaskViewController = AddTaskViewController()
        dummyAddTaskViewController.tabBarItem = UITabBarItem(
            title: "Add Task",
            image: UIImage(systemName: "plus.square", withConfiguration: Const.LargeSFSymbol),
            tag: 2)
        configuredViewControllers.append(dummyAddTaskViewController)

        let doneListViewController = ListViewController(listType: .Done)
        doneListViewController.tabBarItem = UITabBarItem(
            title: "Done",
            image: UIImage(systemName: "checkmark", withConfiguration: Const.LargeSFSymbol),
            tag: 3)
        configuredViewControllers.append(doneListViewController)

        let neverListViewController = ListViewController(listType: .Never)
        neverListViewController.tabBarItem = UITabBarItem(
            title: "Never",
            image: UIImage(systemName: "xmark", withConfiguration: Const.LargeSFSymbol),
            tag: 4)
        configuredViewControllers.append(neverListViewController)
        
        return configuredViewControllers
    }
        
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is AddTaskViewController {
            let addTaskViewController = AddTaskViewController()
            
            self.present(addTaskViewController, animated: true)
            return false
        }
        
        return true
    }
}
