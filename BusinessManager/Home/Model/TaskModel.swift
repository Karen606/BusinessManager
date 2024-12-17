//
//  TaskModel.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 17.12.24.
//

import Foundation

struct TaskModel {
    var id: UUID
    var name: String?
    var info: String?
    var startDate: Date?
    var endDate: Date?
    var startTime: Date?
    var endTime: Date?
    var priority: Int?
    var persons: [String] = []
    var file: Data?
}

enum Priority: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}
