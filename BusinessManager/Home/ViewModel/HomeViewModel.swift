//
//  HomeViewModel.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 17.12.24.
//

import Foundation

class HomeViewModel {
    static let shared = HomeViewModel()
    @Published var tasks: [TaskModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchTasksForToday { [weak self] tasks, _ in
            guard let self = self else { return }
            self.tasks = tasks
        }
    }
    
    func clear() {
        tasks = []
    }
}
