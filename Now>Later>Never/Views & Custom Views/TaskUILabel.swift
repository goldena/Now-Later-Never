//
//  TaskUILabel.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 7.02.21.
//

import UIKit

class TaskUILabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 20)
        numberOfLines = 1
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(text: String) {
        self.init()
        self.text = text
    }
}
