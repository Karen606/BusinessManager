//
//  ContactFormViewController.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 18.12.24.
//

import UIKit
import Combine

class ContactFormViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var surnameTextField: BaseTextField!
    @IBOutlet weak var emailTextField: BaseTextField!
    @IBOutlet weak var phoneTextField: BaseTextField!
    @IBOutlet weak var tagsTextField: BaseTextField!
    @IBOutlet weak var createButton: BaseButton!
    private let viewModel = ContactFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    func setupUI() {
        setNaviagtionCancelButton()
        setNavigationTitle(title: "Adding a Contact")
        titleLabels.forEach({ $0.font = .regular(size: 16) })
        createButton.titleLabel?.font = .semiboldSFPro(size: 20)
        nameTextField.delegate = self
        surnameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        tagsTextField.delegate = self
    }
    
    func subscribe() {
        viewModel.$contact
            .receive(on: DispatchQueue.main)
            .sink { [weak self] contact in
                guard let self = self else { return }
                self.createButton.isEnabled = (contact.name.checkValidation() && contact.surname.checkValidation() && contact.phone.checkValidation() && contact.tags.checkValidation() && contact.email.isValidEmail())
            }
            .store(in: &cancellables)
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func clickedCreate(_ sender: BaseButton) {
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

extension ContactFormViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            viewModel.contact.name = textField.text
        case surnameTextField:
            viewModel.contact.surname = textField.text
        case emailTextField:
            viewModel.contact.email = textField.text
        case phoneTextField:
            viewModel.contact.phone = textField.text
        case tagsTextField:
            viewModel.contact.tags = textField.text
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
