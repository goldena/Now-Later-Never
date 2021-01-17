//
//  AddTaskViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 17.01.21.
//

import UIKit

class AddTaskViewController: UIViewController {

    // MARK: - Properties - Outlets
    
    @IBOutlet weak var TaskTitleTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TaskTitleTextField.delegate = self
        
        addTapOutsideTextFieldGestureRecognizer()
    }

    func addTapOutsideTextFieldGestureRecognizer() {
        
        // Dismissed keyboard after tapping outside an edited field
        let tapOutsideTextField = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        
        tapOutsideTextField.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOutsideTextField)
    }
    
    
    // MARK: - Methods - Actions
    
    @IBAction private func AddTaskButtonPressed(_ sender: UIButton) {
        
        let task = Task(title: TaskTitleTextField.text ?? "No title", category: .Work, date: Date())
        
        persistentStorage.createTask(task, on: .Today)
    }
    
    @IBAction private func CancelButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Extensions
extension UIViewController: UITextFieldDelegate {
    
    // Dismiss keyboard after pressing Return key
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
}
