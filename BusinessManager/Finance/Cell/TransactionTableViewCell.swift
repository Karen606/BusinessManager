//
//  TransactionTableViewCell.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 18.12.24.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        nameLabel.font = .regular(size: 20)
        amountLabel.font = .medium(size: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(transaction: TransactionModel) {
        let color = transaction.type == 0 ? #colorLiteral(red: 0.1450980392, green: 0.4980392157, blue: 0.003921568627, alpha: 1) : #colorLiteral(red: 0.7764705882, green: 0.1490196078, blue: 0.1803921569, alpha: 1)
        nameLabel.textColor = color
        amountLabel.textColor = color
        nameLabel.text = transaction.info
        if transaction.type == 0 {
            amountLabel.text = "+\(transaction.amount?.formattedToString() ?? "")$"
        } else {
            amountLabel.text = "-\(transaction.amount?.formattedToString() ?? "")$"
        }
    }
    
}
