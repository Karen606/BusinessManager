//
//  EventFormViewModel.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 18.12.24.
//

import Foundation

class EventFormViewModel {
    static let shared = EventFormViewModel()
    @Published var event = EventModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveEvent(eventModel: event, completion: completion)
    }
    
    func clear() {
        event = EventModel(id: UUID())
    }
}
