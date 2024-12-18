//
//  EventModel.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 18.12.24.
//

import Foundation

struct EventModel {
    var id: UUID
    var event: Int?
    var startDate: Date?
    var endDate: Date?
    var place: String?
    var info: String?
    var reminder: Int?
    var category: Int?
}

enum EventType: String, CaseIterable {
    case meeting = "Meeting"
    case task = "Task"
}

enum Reminder: String, CaseIterable {
    case _15 = "15 minutes before start"
    case _30 = "30 minutes before start"
    case _60 = "60 minutes before start"
    case _2 = "2 hours before start"
    case _4 = "4 hours before start"
}

enum EventCategory: String, CaseIterable {
    case personal = "Personal"
    case business = "Business"
    case conference = "Conference"
}
