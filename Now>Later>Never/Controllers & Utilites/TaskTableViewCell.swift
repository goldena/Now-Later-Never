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
    var cellStackView = UIStackView()
    
    // MARK: - Methods - View Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Configure task title label
        taskTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        taskTitleLabel.font = UIFont.systemFont(ofSize: 20)
        taskTitleLabel.numberOfLines = 1

        // Configure task optional description
        taskDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        taskDescriptionLabel.font = UIFont.systemFont(ofSize: 20)
        taskDescriptionLabel.textColor = UIColor.systemGray
        taskDescriptionLabel.numberOfLines = 0
        
        // Confrgure StackView
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.axis = .vertical
        cellStackView.distribution = .fillEqually
        
        contentView.addSubview(cellStackView)
        cellStackView.addArrangedSubview(taskTitleLabel)
        cellStackView.addArrangedSubview(taskDescriptionLabel)
        
        // Add constraints to StackView
        let margins = contentView.layoutMarginsGuide

        NSLayoutConstraint.activate([
            cellStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            cellStackView.topAnchor.constraint(equalTo: margins.topAnchor),
            cellStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            cellStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
