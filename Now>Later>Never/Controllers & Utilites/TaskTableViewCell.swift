//
//  TaskTableViewCell.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 3.01.21.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    // MARK: - Properties - Outlets
    @IBOutlet weak var TaskTitleLabel: UILabel!
    @IBOutlet weak var TaskDescriptionLabel: UILabel!
    @IBOutlet weak var TaskDescriptionStackView: UIStackView!
    
    // MARK: - Methods - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
            
//        TaskTitleLabel.text = nil
//        TaskDescriptionLabel.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
