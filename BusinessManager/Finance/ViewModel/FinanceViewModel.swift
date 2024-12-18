//
//  FinanceViewModel.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 18.12.24.
//

import Foundation

class FinanceViewModel {
    static let shared = FinanceViewModel()
    private var data: [TransactionModel] = []
    @Published var transactions: [TransactionModel] = []
    var selectedType: Int = 2
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchTransaction { [weak self] transactions, _ in
            guard let self = self else { return }
            self.data = transactions
            self.filter()
        }
    }
    
    private func filter() {
        if selectedType == 2 {
            self.transactions = data
        } else {
            self.transactions = data.filter({ $0.type == selectedType })
        }
    }
    
    func chooseFilter(by index: Int) {
        self.selectedType = index
        self.filter()
    }
    
}
