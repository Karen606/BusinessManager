//
//  TaskTableViewCell.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 17.12.24.
//

import UIKit

class TaskDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var priorityImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    private var task: TaskModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        nameLabel.font = .regular(size: 17)
        nameLabel.font = .regular(size: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(task: TaskModel) {
        self.task = task
        priorityImageView.image = UIImage(named: "priority\(Priority.allCases[task.priority ?? 0].rawValue)")
        nameLabel.text = "\(task.startTime?.toString(format: "HH:mm") ?? "") \(task.name ?? "")"
        detailsLabel.text = ""
    }
    
    override func prepareForReuse() {
        task = nil
        moreButton.isSelected = false
    }
    
    @IBAction func clickedShowMore(_ sender: UIButton) {
        guard let task = task else { return }
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            let persons = task.persons.joined(separator: ", ")
            detailsLabel.text = "End: \(task.endTime?.toString(format: "HH:mm") ?? "")\nDescription: \(task.info ?? "") \nPersons: \(persons)"
        } else {
            detailsLabel.text = ""
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        if let tableView = self.superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}
