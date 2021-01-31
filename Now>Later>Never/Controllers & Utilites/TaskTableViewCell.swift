//
//  TaskTableViewCell.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 3.01.21.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var taskTitleLabel = UILabel()
    var taskDescriptionLabel = UILabel()
    var taskDescriptionStackView = UIStackView()
    
    // MARK: - Methods - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
            
        backgroundColor = .gray
        
        taskTitleLabel.text = "test"
        taskDescriptionLabel.text = "test"
        contentView.addSubview(taskTitleLabel)
        contentView.addSubview(taskDescriptionLabel)
        contentView.addSubview(taskDescriptionStackView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
