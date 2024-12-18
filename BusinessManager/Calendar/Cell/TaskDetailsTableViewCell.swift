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
    private var event: EventModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        nameLabel.font = .regular(size: 17)
        nameLabel.font = .regular(size: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(event: EventModel) {
        self.event = event
        let image = event.event == 0 ? UIImage.priorityHigh : UIImage.priorityMedium
        priorityImageView.image = image
        nameLabel.text = "\(event.startDate?.toString(format: "HH:mm") ?? "") \(EventType.allCases[event.event ?? 0].rawValue)"
        detailsLabel.text = ""
    }
    
    override func prepareForReuse() {
        event = nil
        moreButton.isSelected = false
    }
    
    @IBAction func clickedShowMore(_ sender: UIButton) {
        guard let event = event else { return }
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            detailsLabel.text = "End: \(event.endDate?.toString(format: "HH:mm") ?? "")\nPlace: \(event.place ?? "")\nDescription: \(event.info ?? "") \nCategory: \(EventCategory.allCases[event.category ?? 0].rawValue)"
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
