//
//  TransactionFormViewModel.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 18.12.24.
//

import Foundation

class TransactionFormViewModel {
    static let shared = TransactionFormViewModel()
    @Published var transaction = TransactionModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveTransaction(transactionModel: transaction, completion: completion)
    }
    
    func clear() {
        transaction = TransactionModel(id: UUID())
    }
}
