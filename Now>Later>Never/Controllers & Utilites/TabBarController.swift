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
        todayListViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        configuredViewControllers.append(todayListViewController)
        
        let laterListViewController = ListViewController(listType: .Later)
        laterListViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        configuredViewControllers.append(laterListViewController)

        let addTaskViewController = AddTaskViewController()
        addTaskViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        configuredViewControllers.append(addTaskViewController)

        let doneListViewController = ListViewController(listType: .Done)
        doneListViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 3)
        configuredViewControllers.append(doneListViewController)

        let neverListViewController = ListViewController(listType: .Never)
        neverListViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 4)
        configuredViewControllers.append(neverListViewController)
        
        return configuredViewControllers
    }
    
    func addTaskBarItem(name: String, image: String, selectedImage: String?) -> UITabBarItem {
        let newTabBarItem = UITabBarItem()
        
        let largeSFSymbol = UIImage.SymbolConfiguration(scale: .large)

        // TODO: Force Unwrapping, consider refactoring
        let newTaskNormalImage = UIImage(systemName: image, withConfiguration: largeSFSymbol)!
            .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            .withTintColor(.systemGreen)
        
        newTabBarItem.image = newTaskNormalImage

        if let selectedImage = selectedImage {
            let newTaskSelectedImage = UIImage(systemName: selectedImage, withConfiguration: largeSFSymbol)!
                .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                .withTintColor(.systemBlue)
            
            newTabBarItem.selectedImage = newTaskSelectedImage
        }
                
        return newTabBarItem
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
//        if viewController is AddTaskViewController {
//            guard let addTaskViewController = viewController as? AddTaskViewController else {
//                fatalError("Could not instantiate ViewController for Add Task tab")
//            }
//            
//            self.present(addTaskViewController, animated: true)
//            return false
//        }
        
        return true
    }
}
