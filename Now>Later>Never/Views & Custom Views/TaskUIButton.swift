//
//  TaskUIButton.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 8.02.21.
//

import UIKit

class TaskUIButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.cornerRadius = 8
        backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init()
        
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 20)
        setTitleColor(.label, for: .normal)
        // setTitleColor(.secondaryLabel, for: .selected)
    }
}
