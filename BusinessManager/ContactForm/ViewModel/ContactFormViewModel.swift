//
//  ContactFormViewModel.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 18.12.24.
//

import Foundation

class ContactFormViewModel {
    static let shared = ContactFormViewModel()
    @Published var contact = ContactModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveContact(contactModel: contact, completion: completion)
    }
    
    func clear() {
        contact = ContactModel(id: UUID())
    }
}
