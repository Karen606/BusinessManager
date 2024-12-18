//
//  FinanceViewController.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 17.12.24.
//

import UIKit
import Combine

class FinanceViewController: UIViewController {

    @IBOutlet var filterButtons: [FilterButton]!
    @IBOutlet weak var transactionsTableView: UITableView!
    private let viewModel = FinanceViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        transactionsTableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionTableViewCell")
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$transactions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.filterButtons.forEach({ $0.isSelected = false })
                self.filterButtons[self.viewModel.selectedType].isSelected = true
                self.transactionsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @IBAction func clickedAddTransaction(_ sender: UIButton) {
        let transactionFormVC = TransactionFormViewController(nibName: "TransactionFormViewController", bundle: nil)
        transactionFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchData()
            }
        }
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(transactionFormVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    @IBAction func chooseFilter(_ sender: FilterButton) {
        viewModel.chooseFilter(by: sender.tag)
    }
}

extension FinanceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        cell.configure(transaction: viewModel.transactions[indexPath.row])
        return cell
    }
}
