//
//  FilterButton.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 03.12.24.
//

import UIKit

class FilterButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .baseBlue : #colorLiteral(red: 0.7267200351, green: 0.7303821445, blue: 0.7370898724, alpha: 0.2990738825)
            self.titleLabel?.font = isSelected ? .semibold(size: 18) : .medium(size: 18)
        }
    }
    
    func commonInit() {
        self.titleLabel?.font = .regular(size: 15)
        self.setTitleColor(#colorLiteral(red: 0.631372549, green: 0.631372549, blue: 0.631372549, alpha: 1), for: .normal)
        self.setTitleColor(.white, for: .selected)
        self.backgroundColor = #colorLiteral(red: 0.7267200351, green: 0.7303821445, blue: 0.7370898724, alpha: 0.2990738825)
        self.layer.cornerRadius = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
