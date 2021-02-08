//
//  TaskUIStackView.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 7.02.21.
//

import UIKit

class TaskUIStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, spacing: CGFloat) {
        self.init()

        self.distribution = distribution
        self.axis = axis
        self.spacing = spacing
    }
}
