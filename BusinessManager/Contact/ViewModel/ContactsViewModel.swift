//
//  ContactsViewModel.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 18.12.24.
//

import Foundation

class ContactsViewModel {
    static let shared = ContactsViewModel()
    private var data: [ContactModel] = []
    @Published var contacts: [ContactModel] = []
    private var searchValue: String?
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchContacts { [weak self] contacts, _ in
            guard let self = self else { return }
            self.data = contacts
            self.search(value: self.searchValue)
        }
    }
    
    func search(value: String?) {
        searchValue = value
        let trimmedSearch = searchValue?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        self.contacts = data.filter({ trimmedSearch == nil || $0.tags?.lowercased().contains(trimmedSearch!) == true})
    }
    
    func clear() {
        data = []
        contacts = []
    }
}
