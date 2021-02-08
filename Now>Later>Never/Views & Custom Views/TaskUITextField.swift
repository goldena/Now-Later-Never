//
//  TaskUITextField.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 8.02.21.
//

import UIKit

class TaskUITextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 20)
        backgroundColor = .placeholderText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String) {
        self.init()
        
        self.placeholder = placeholder
    }
}
