//
//  TransactionFormViewController.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 18.12.24.
//

import UIKit
import DropDown
import Combine

class TransactionFormViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var dropDownImageView: UIImageView!
    @IBOutlet weak var amountTextField: PriceTextField!
    @IBOutlet weak var dateTextField: BaseTextField!
    @IBOutlet weak var descriptionTextField: BaseTextField!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var saveButton: BaseButton!
    private let dropDown = DropDown()
    private let datePicker = UIDatePicker()
    var completion: (() -> ())?
    private let viewModel = TransactionFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    override func viewDidLayoutSubviews() {
        self.dropDown.width = typeButton.bounds.width
        self.dropDown.bottomOffset = CGPoint(x: self.typeButton.frame.minX, y: self.typeButton.frame.maxY + 2)
    }
    
    func setupUI() {
        setNaviagtionCancelButton()
        setNavigationTitle(title: "Add a transaction")
        titleLabels.forEach({ $0.font = .regular(size: 16) })
        amountTextField.setupRightViewIcon(.dollar, size: CGSize(width: 40, height: 40))
        dateTextField.setupRightViewIcon(.calendar, size: CGSize(width: 40, height: 40))
        descriptionTextField.delegate = self
        amountTextField.baseDelegate = self
        typeButton.layer.borderColor = UIColor.black.cgColor
        typeButton.layer.borderWidth = 1
        typeButton.layer.cornerRadius = 6
        typeButton.titleLabel?.font = .regular(size: 14)
        let data: [String] = TransactionType.allCases.map { $0.rawValue }
        dropDown.backgroundColor = .white
        dropDown.setupCornerRadius(8)
        dropDown.dataSource = data
        dropDown.anchorView = typeView
        dropDown.direction = .bottom
        DropDown.appearance().textColor = .black
        DropDown.appearance().textFont = .regular(size: 15) ?? .boldSystemFont(ofSize: 18)
        DropDown.appearance().selectionBackgroundColor = .clear
        dropDown.addShadow()
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.viewModel.transaction.type = index
            self.typeButton.setTitle(TransactionType.allCases[index].rawValue, for: .normal)
            self.dropDownImageView.isHighlighted = false
        }
        
        dropDown.cancelAction = { [weak self] in
            guard let self = self else { return }
            self.dropDownImageView.isHighlighted = false
        }
        
        datePicker.locale = NSLocale.current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(startDatePickerValueChanged), for: .valueChanged)
        dateTextField.inputView = datePicker
    }
    
    func subscribe() {
        viewModel.$transaction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transsaction in
                guard let self = self else { return }
                self.saveButton.isEnabled = (transsaction.type != nil && transsaction.amount != nil && transsaction.date != nil && transsaction.info.checkValidation())
            }
            .store(in: &cancellables)
    }

    @objc func startDatePickerValueChanged() {
        viewModel.transaction.date = datePicker.date
        dateTextField.text = datePicker.date.toString(format: "dd/MM/yy")
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func chooseTransactionType(_ sender: UIButton) {
        dropDown.show()
        dropDownImageView.isHighlighted = !dropDown.isHidden
    }
    
    @IBAction func clickedSave(_ sender: BaseButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.completion?()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension TransactionFormViewController: UITextFieldDelegate, PriceTextFielddDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == descriptionTextField {
            viewModel.transaction.info = textField.text
        } else if textField == amountTextField {
            viewModel.transaction.amount = Double(textField.text ?? "")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
