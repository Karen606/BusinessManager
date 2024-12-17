//
//  TaskTableViewCell.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 17.12.24.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var priorityImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        nameLabel.font = .regular(size: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 
    func configure(task: TaskModel) {
        priorityImageView.image = UIImage(named: "priority\(Priority.allCases[task.priority ?? 0].rawValue)")
        nameLabel.text = "\(task.startTime?.toString(format: "HH:mm") ?? "") \(task.name ?? "")"
    }
}
