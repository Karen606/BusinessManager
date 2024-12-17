//
//  PersonFormTableViewCell.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 17.12.24.
//

import UIKit

protocol PersonFormTableViewCellDelegate: AnyObject {
    func changeValue(value: String?, cell: UITableViewCell)
}

class PersonFormTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextField: BaseTextField!
    weak var delegate: PersonFormTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        nameTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(person: String?) {
        nameTextField.text = person
    }
}

extension PersonFormTableViewCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.changeValue(value: textField.text, cell: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
    }
}
