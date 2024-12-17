//
//  TasksViewModel.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 17.12.24.
//

import Foundation

class TasksViewModel {
    static let shared = TasksViewModel()
    @Published var tasks: [TaskModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchTasks { [weak self] tasks, _ in
            guard let self = self else { return }
            self.tasks = tasks
        }
    }
    
    func clear() {
        tasks = []
    }
}
