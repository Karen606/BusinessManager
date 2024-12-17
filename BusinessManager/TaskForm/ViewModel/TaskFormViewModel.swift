//
//  TaskFormViewModel.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 17.12.24.
//

import Foundation

class TaskFormViewModel {
    static let shared = TaskFormViewModel()
    @Published var task = TaskModel(id: UUID())
    var previousPersonsCount: Int = 0

    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveTask(taskModel: task, completion: completion)
    }
    
    func addPerson() {
        task.persons.append("")
    }
    
    func clear() {
        task = TaskModel(id: UUID())
        previousPersonsCount = 0
    }
}
