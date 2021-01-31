//
//  AddTaskViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 17.01.21.
//

import UIKit

class AddTaskViewController: UIViewController, PersistentStorageCRUD {
    
    // MARK: - Properties
    private var taskTitleTextField: UITextField!
    private var taskDescriptionTextField: UITextField!
    
    private var categoryOfTaskSegmentedControl: UISegmentedControl!
    private var deadlineSegmentedControl: UISegmentedControl!
    
    private weak var addTaskBottomMarginConstraint: NSLayoutConstraint!
    
    override func loadView() {
        view = UIView()
        
        view.backgroundColor = .red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initSegmentedControl(categoryOfTaskSegmentedControl, with: Category.rawValues())
        // initSegmentedControl(deadlineSegmentedControl, with: ListType.rawValues())
        
        // taskTitleTextField.delegate = self
        
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
        
        self.addTaskBottomMarginConstraint.constant = keyboardFrame.cgRectValue.height
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.addTaskBottomMarginConstraint.constant = 0
        
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
    
    func getSegmentName(segmentedControl: UISegmentedControl) -> String {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        
        guard selectedIndex != UISegmentedControl.noSegment,
              let selectedTitle = segmentedControl.titleForSegment(at: selectedIndex) else {
            fatalError("No segment of UISegmentedcontrol was selected or no title exists")
        }
        
        return selectedTitle
    }
    
    // MARK: - Methods - Actions
    @IBAction private func AddTaskButtonPressed(_ sender: UIButton) {
        // Segment is selected, its Title exists, its Category is valid
        let categoryTitle = getSegmentName(segmentedControl: categoryOfTaskSegmentedControl)
        let deadlineTitle = getSegmentName(segmentedControl: deadlineSegmentedControl)
        
        guard let category = Category.init(rawValue: categoryTitle),
              let listType = ListType.init(rawValue: deadlineTitle) else {
            fatalError("Selected segment is not valid")
        }
        
        guard let taskTitle = taskTitleTextField.text,
              taskTitle != "" else {
            // Alert if a New Task's Title is empty
            showAlert(title: "No title entered", message: "Please add a title to the Task")
            return
        }
        
        let taskDescription = taskDescriptionTextField.text
        // If a Task is added to the Done listType, then mark as done.
        let done = listType == .Done
        
        #warning("Temrorary impementation")
        let task = Task(
            title: taskTitle + category.rawValue,
            description: taskDescription,
            category: category,
            date: Date(),
            done: done
        )
        addTask(task, to: listType)
        
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
