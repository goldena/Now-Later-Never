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
        
        let largeSFSymbol = UIImage.SymbolConfiguration(scale: .large)
        
        let todayListViewController = ListViewController(listType: .Today)
        todayListViewController.tabBarItem = UITabBarItem(
            title: "Today",
            image: UIImage(systemName: "list.bullet", withConfiguration: largeSFSymbol),
            tag: 0)
        configuredViewControllers.append(todayListViewController)
        
        let laterListViewController = ListViewController(listType: .Later)
        laterListViewController.tabBarItem = UITabBarItem(
            title: "Later",
            image: UIImage(systemName: "arrow.right", withConfiguration: largeSFSymbol),
            tag: 1)
        configuredViewControllers.append(laterListViewController)

        // TODO: Consider refactoring
        let dummyAddTaskViewController = AddTaskViewController()
        dummyAddTaskViewController.tabBarItem = UITabBarItem(
            title: "Add Task",
            image: UIImage(systemName: "plus.square", withConfiguration: largeSFSymbol),
            tag: 2)
        configuredViewControllers.append(dummyAddTaskViewController)

        let doneListViewController = ListViewController(listType: .Done)
        doneListViewController.tabBarItem = UITabBarItem(
            title: "Done",
            image: UIImage(systemName: "checkmark", withConfiguration: largeSFSymbol),
            tag: 3)
        configuredViewControllers.append(doneListViewController)

        let neverListViewController = ListViewController(listType: .Never)
        neverListViewController.tabBarItem = UITabBarItem(
            title: "Never",
            image: UIImage(systemName: "xmark", withConfiguration: largeSFSymbol),
            tag: 4)
        configuredViewControllers.append(neverListViewController)
        
        return configuredViewControllers
    }
    
    func addTaskBarItem(name: String, image: String, selectedImage: String?) -> UITabBarItem {
        let newTabBarItem = UITabBarItem()
        
        //let largeSFSymbol = UIImage.SymbolConfiguration(scale: .large)

        // TODO: Force Unwrapping, consider refactoring
//        let newTaskNormalImage = UIImage(systemName: image, withConfiguration: largeSFSymbol)!
//            .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//            .withTintColor(.systemGreen)
//
//        newTabBarItem.image = newTaskNormalImage
//
//        if let selectedImage = selectedImage {
//            let newTaskSelectedImage = UIImage(systemName: selectedImage, withConfiguration: largeSFSymbol)!
//                .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//                .withTintColor(.systemBlue)
//
//            newTabBarItem.selectedImage = newTaskSelectedImage
//        }
                
        return newTabBarItem
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
