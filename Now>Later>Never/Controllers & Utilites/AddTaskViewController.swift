//
//  AddTaskViewController.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 17.01.21.
//

import UIKit

class AddTaskViewController: UIViewController, PersistentStorageCRUD {
    
    // MARK: - Properties
    private var mainStackView = TaskUIStackView(axis: .vertical, distribution: .fillEqually, spacing: 24)

    private var taskStackView = TaskUIStackView(axis: .vertical, distribution: .fillEqually, spacing: 8)
    private var taskTitleLabel = TaskUILabel(text: "Task Title")
    private var taskTitleTextField = TaskUITextField(placeholder: "Enter a New Task")
    
    private var descriptionStackView = TaskUIStackView(axis: .vertical, distribution: .fillEqually, spacing: 8)
    private var taskDescriptionLabel = TaskUILabel(text: "Optional Task Description")
    private var taskDescriptionTextField = TaskUITextField(placeholder: "Enter a New Task's Description")

    private var categoryStackView = TaskUIStackView(axis: .vertical, distribution: .fillEqually, spacing: 8)
    private var categoryTaskLabel = TaskUILabel(text: "Task Category")
    private var categorySegmentedControl = UISegmentedControl()

    private var deadlineStackView = TaskUIStackView(axis: .vertical, distribution: .fillEqually, spacing: 8)
    private var deadlineLabel = TaskUILabel(text: "Task Deadline")
    private var deadlineSegmentedControl = UISegmentedControl()
    
    private var buttonsStackView = TaskUIStackView(axis: .horizontal, distribution: .fillEqually, spacing: 24)
    private var saveButton = TaskUIButton(title: "Add Task")
    private var cancelButton = TaskUIButton(title: "Cancel")
    
    private var topMarginConstraint = NSLayoutConstraint()
    private var bottomMarginConstraint = NSLayoutConstraint()
         
    // MARK: - Methods - View Lifecycle
    private func constraintViewToMargins(_ viewToConstraint: UIView) {
        guard let margins = viewToConstraint.superview?.layoutMarginsGuide else {
            fatalError("Could not get margins of a superView")
        }
                
        NSLayoutConstraint.activate([
            viewToConstraint.leadingAnchor.constraint(
                equalTo: margins.leadingAnchor,
                constant: systemMinimumLayoutMargins.leading
            ),
//            viewToConstraint.topAnchor.constraint(
//                equalTo: margins.topAnchor,
//                constant: systemMinimumLayoutMargins.top
//            ),
            viewToConstraint.trailingAnchor.constraint(
                equalTo: margins.trailingAnchor,
                constant: systemMinimumLayoutMargins.trailing
            ),
//            viewToConstraint.bottomAnchor.constraint(
//                equalTo: margins.bottomAnchor,
//                constant: systemMinimumLayoutMargins.bottom
//            ),
        ])
   }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground

        // Create the Main StackView and add constraints
        view.addSubview(mainStackView)
        constraintViewToMargins(mainStackView)
        
        // Add substacks to the main stack
        mainStackView.addArrangedSubview(categoryStackView)
        mainStackView.addArrangedSubview(deadlineStackView)
        mainStackView.addArrangedSubview(taskStackView)
        mainStackView.addArrangedSubview(descriptionStackView)
        mainStackView.addArrangedSubview(buttonsStackView)
            
        // Init and activate the top and the bottom anchor constraints for moving items
        // higher, so they won't be blocked by the appearing keyboard
        topMarginConstraint = mainStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: systemMinimumLayoutMargins.top)
        topMarginConstraint.isActive = false
        
        bottomMarginConstraint = mainStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: systemMinimumLayoutMargins.bottom)
        bottomMarginConstraint.isActive = true
        
        categoryStackView.addArrangedSubview(categoryTaskLabel)
        categoryStackView.addArrangedSubview(categorySegmentedControl)
        initSegmentedControl(categorySegmentedControl, with: Category.rawValues())
        
        deadlineStackView.addArrangedSubview(deadlineLabel)
        deadlineStackView.addArrangedSubview(deadlineSegmentedControl)
        initSegmentedControl(deadlineSegmentedControl, with: ListType.rawValues())
        
        taskStackView.addArrangedSubview(taskTitleLabel)
        taskStackView.addArrangedSubview(taskTitleTextField)
        
        descriptionStackView.addArrangedSubview(taskDescriptionLabel)
        descriptionStackView.addArrangedSubview(taskDescriptionTextField)
        
        buttonsStackView.addArrangedSubview(saveButton)
        buttonsStackView.addArrangedSubview(cancelButton)
        
        saveButton.addTarget(self, action: #selector(addTaskButtonPressed(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTitleTextField.delegate = self
        taskDescriptionTextField.delegate = self
        
        // Adds gesture recognizer to dismiss a keyboard when there is a tap outside of an edited field
        // tapOutsideTextFieldGestureRecognizer()
        
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
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let info = notification.userInfo,
              let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        topMarginConstraint.isActive = true
        bottomMarginConstraint.constant = -keyboardFrame.cgRectValue.height
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        topMarginConstraint.isActive = false
        bottomMarginConstraint.constant = systemMinimumLayoutMargins.bottom
        
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
    @objc private func addTaskButtonPressed(_ sender: UIButton) {
        // Segment is selected, its Title exists, its Category is valid
        let categoryTitle = getSegmentName(segmentedControl: categorySegmentedControl)
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
        let done = (listType == .Done)
        
        let task = Task(
            title: taskTitle,
            description: taskDescription,
            category: category,
            date: Date(),
            done: done
        )
        addTask(task, to: listType)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func cancelButtonPressed(_ sender: UIButton) {
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
    
    // Shows arerts with single Okay button
    func showAlert(title alertTitle: String, message alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
