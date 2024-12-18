//
//  CalendarViewModel.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 17.12.24.
//

import Foundation

class CalendarViewModel {
    static let shared = CalendarViewModel()
    var data: [EventModel] = []
    @Published var events: [EventModel] = []
    var selectedDate = Date()
    var selectedType = 0
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchEvents(for: selectedDate) { [weak self] tasks, _ in
            guard let self = self else { return }
            self.data = tasks
            self.filter()
        }
    }
    
    func filter() {
        events = data.filter({ $0.event == selectedType })
    }
    
    func choosePriority(index: Int) {
        selectedType = index
        filter()
    }
    
    func chooseDate(by date: Date) {
        selectedDate = date
        fetchData()
    }
    
    func clear() {
        data = []
        events = []
    }
}
