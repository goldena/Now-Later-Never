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
    
    @IBOutlet weak var AddTaskBottomMarginConstraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        TaskTitleTextField.delegate = self
        
        tapOutsideTextFieldGestureRecognizer()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {

        guard let info = notification.userInfo,
              let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        UIView.animate(withDuration: 0.1) {
            self.AddTaskBottomMarginConstraint.constant = keyboardFrame.size.height
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {

        guard let info = notification.userInfo,
              let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        UIView.animate(withDuration: 0.1) {
            self.AddTaskBottomMarginConstraint.constant = 0
        }
    }
    
    func tapOutsideTextFieldGestureRecognizer() {
        
        // Dismissed keyboard after tapping outside an edited field
        let tapOutsideTextField = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        
        tapOutsideTextField.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOutsideTextField)
    }
    
    
    // MARK: - Methods - Actions
    
    @IBAction private func AddTaskButtonPressed(_ sender: UIButton) {
        
        let task = Task(title: TaskTitleTextField.text ?? "No title", category: .Work, date: Date())
        
        // TODO: Replace with Persistend Storage Interface
        persistentStorage.createTask(task, on: .Today)
        
        self.dismiss(animated: true, completion: nil)
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
