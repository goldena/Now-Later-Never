//
//  AddTaskViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 17.01.21.
//

import UIKit

class AddTaskViewController: UIViewController, PersistentStorageCRUD {
    
    // MARK: - Properties
    @IBOutlet private weak var TaskTitleTextField: UITextField!
    @IBOutlet private weak var TaskDescriptionTextField: UITextField!
    
    @IBOutlet private weak var CategoryOfTaskSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var DeadlineSegmentedControl: UISegmentedControl!
    
    @IBOutlet private weak var AddTaskBottomMarginConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSegmentedControl(CategoryOfTaskSegmentedControl, with: Category.rawValues)
        initSegmentedControl(DeadlineSegmentedControl, with: ListType.rawValues)
        
        TaskTitleTextField.delegate = self
        
        // Adds gesture recognizer to dismiss a keyboard when there is a tap outside of an edited field
        tapOutsideTextFieldGestureRecognizer()
        
        // Adds Observers to show keyboard without blocking any other UI elements
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let info = notification.userInfo,
              let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        self.AddTaskBottomMarginConstraint.constant = keyboardFrame.cgRectValue.height
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.AddTaskBottomMarginConstraint.constant = 0
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    // Dismissed keyboard after tapping outside of an edited field
    func tapOutsideTextFieldGestureRecognizer() {
        let tapOutsideTextField = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapOutsideTextField.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOutsideTextField)
    }
    
    // Programmatic init of UISegmentedControls from a dataSource: [String]
    private func initSegmentedControl(_ segmentedControl: UISegmentedControl, with segmentNames: [String]) {
        segmentedControl.removeAllSegments()
        
        for index in 0..<segmentNames.count {
            segmentedControl.insertSegment(withTitle: segmentNames[index], at: index, animated: true)
        }
        
        segmentedControl.selectedSegmentIndex = 0
    }
    
    // MARK: - Methods - Actions
    @IBAction private func AddTaskButtonPressed(_ sender: UIButton) {
        
        let selectedSegmentIndex = CategoryOfTaskSegmentedControl.selectedSegmentIndex
        
        // Segment is selected, its Title exists, its Category is valid
        guard selectedSegmentIndex != UISegmentedControl.noSegment,
              let selectedSegmentTitle = CategoryOfTaskSegmentedControl.titleForSegment(at: selectedSegmentIndex),
              let category = Category.init(rawValue: selectedSegmentTitle) else {
            fatalError("No segment of UISegmentedcontrol was selected || no title exists || invalid category")
        }
        
        guard let taskTitle = TaskTitleTextField.text, taskTitle != "" else {
            // Alert if a New Task's Title is empty
            showAlert(title: "No title entered", message: "Please add a title to the Task")
            return
        }
        
        let task = Task(title: taskTitle, category: category, date: Date())
        addTask(task, to: .Done)
        
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

extension UIViewController {
    
    func showAlert(title alertTitle: String, message alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
