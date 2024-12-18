//
//  ContactViewController.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 17.12.24.
//

import UIKit
import Combine
import MessageUI

class ContactViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var contactsTableView: UITableView!
    private let viewModel = ContactsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        searchTextField.layer.cornerRadius = 8
        searchTextField.layer.borderColor = #colorLiteral(red: 0.6705882353, green: 0.6745098039, blue: 0.6823529412, alpha: 1)
        searchTextField.layer.borderWidth = 1
        searchTextField.setLeftViewIcon(.search)
        searchTextField.delegate = self
        searchTextField.font = .regularSFPro(size: 18)
        contactsTableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$contacts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.contactsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @IBAction func clickedAddContact(_ sender: UIButton) {
        let contactFormVC = ContactFormViewController(nibName: "ContactFormViewController", bundle: nil)
        contactFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchData()
            }
        }
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(contactFormVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}

extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.contacts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
        cell.configure(contact: viewModel.contacts[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        8
    }
}

extension ContactViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.search(value: textField.text)
    }
}

extension ContactViewController: ContactTableViewCellDelegate {
    func openEmail(address: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients([address])
            present(mailComposeVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Mail Not Available",
                message: "Please configure a Mail account in your settings.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    func openPhone(phone: String) {
        if let phoneURL = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }
    }
    
    
}

extension ContactViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
