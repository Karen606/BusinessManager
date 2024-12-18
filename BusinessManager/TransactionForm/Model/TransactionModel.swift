//
//  TransactionModel.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 18.12.24.
//

import Foundation

struct TransactionModel {
    var id: UUID
    var type: Int?
    var amount: Double?
    var date: Date?
    var info: String?
}

enum TransactionType: String, CaseIterable {
    case income = "Income"
    case expense = "Expense"
}
