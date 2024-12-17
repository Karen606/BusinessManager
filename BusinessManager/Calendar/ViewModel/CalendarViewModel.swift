//
//  CalendarViewModel.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 17.12.24.
//

import Foundation

class CalendarViewModel {
    static let shared = CalendarViewModel()
    var data: [TaskModel] = []
    @Published var tasks: [TaskModel] = []
    var selectedDate = Date()
    var selectedPriority = 0
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchTasks(for: selectedDate) { [weak self] tasks, _ in
            guard let self = self else { return }
            self.data = tasks
            self.filter()
        }
    }
    
    func filter() {
        tasks = data.filter({ $0.priority == selectedPriority })
    }
    
    func choosePriority(index: Int) {
        selectedPriority = index
        filter()
    }
    
    func chooseDate(by date: Date) {
        selectedDate = date
        fetchData()
    }
    
    func clear() {
        data = []
        tasks = []
    }
}
