//
//  ContactTableViewCell.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 18.12.24.
//

import UIKit

protocol ContactTableViewCellDelegate: AnyObject {
    func openEmail(address: String)
    func openPhone(phone: String)
}

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    weak var delegate: ContactTableViewCellDelegate?
    private var contact: ContactModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        nameLabel.font = .regularSFPro(size: 15)
        bgView.layer.cornerRadius = 6
        bgView.layer.borderColor = #colorLiteral(red: 0.3921568627, green: 0.768627451, blue: 0.9450980392, alpha: 1)
        bgView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(contact: ContactModel) {
        self.contact = contact
        nameLabel.text = "\(contact.name ?? "") \(contact.surname ?? "")"
    }
    
    override func prepareForReuse() {
        contact = nil
    }
    
    @IBAction func clickedEmail(_ sender: UIButton) {
        if let email = contact?.email {
            delegate?.openEmail(address: email)
        }
    }
    
    @IBAction func clickedPhone(_ sender: UIButton) {
        if let phone = contact?.phone {
            delegate?.openPhone(phone: phone)
        }
    }
}
