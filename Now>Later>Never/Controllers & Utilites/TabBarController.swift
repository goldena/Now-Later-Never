//
//  TabBarControllerViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 14.01.21.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var persistentStorage = PersistentStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        // customizeAddTaskTabBarItem()
    }
     
    func customizeAddTaskTabBarItem() {
        
        var addTaskTabBarItem = UITabBarItem()
        
        let largeSFSymbol = UIImage.SymbolConfiguration(scale: .large)
                
        let addTaskNormalImage = UIImage(systemName: "plus.square", withConfiguration: largeSFSymbol)!
            .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            .withTintColor(.systemGreen)
        
        let addTaskSelectedImage = UIImage(systemName: "plus.square.fill", withConfiguration: largeSFSymbol)!
            .withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            .withTintColor(.systemBlue)
             
        for item in self.tabBar.items! {
            if item.tag == 1 {
                addTaskTabBarItem = item
            }
        }
                
        addTaskTabBarItem.image = addTaskNormalImage
        addTaskTabBarItem.selectedImage = addTaskSelectedImage
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        
        guard type(of: viewController) == AddTaskViewController.self
        else {
            return true
        }

        guard let addTaskViewController = tabBarController.storyboard?.instantiateViewController(withIdentifier: "Add Task")
        else {
            fatalError("Could not instantiate ViewController for Add Task tab")
        }
        
        tabBarController.present(addTaskViewController, animated: true)
        return false
    }

}
