//
//  CoreDataManager.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 17.12.24.
//


import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BusinessManager")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveTask(taskModel: TaskModel, completion: @escaping (Error?) -> Void) {
        let id = taskModel.id
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let task: Task
                
                if let existingTask = results.first {
                    task = existingTask
                } else {
                    task = Task(context: backgroundContext)
                    task.id = id
                }
                
                task.name = taskModel.name
                task.info = taskModel.info
                task.startDate = taskModel.startDate
                task.endDate = taskModel.endDate
                task.startTime = taskModel.startTime
                task.endTime = taskModel.endTime
                task.priority = Int32(taskModel.priority ?? 0)
                task.persons = taskModel.persons
                task.file = taskModel.file
                
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchTasks(completion: @escaping ([TaskModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var tasksModel: [TaskModel] = []
                for result in results {
                    let taskModel = TaskModel(id: result.id ?? UUID(), name: result.name, info: result.info, startDate: result.startDate, endDate: result.endDate, startTime: result.startTime, endTime: result.endTime, priority: Int(result.priority), persons: result.persons ?? [], file: result.file)
                    tasksModel.append(taskModel)
                }
                DispatchQueue.main.async {
                    completion(tasksModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func fetchTasksForToday(completion: @escaping ([TaskModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            
            let calendar = Calendar.current
            let now = Date()
            let startOfDay = calendar.startOfDay(for: now) // Start of today
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)! // Start of next day
            
            fetchRequest.predicate = NSPredicate(format: "startDate >= %@ AND startDate < %@", startOfDay as NSDate, endOfDay as NSDate)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var tasksModel: [TaskModel] = []
                for result in results {
                    let taskModel = TaskModel(id: result.id ?? UUID(), name: result.name, info: result.info, startDate: result.startDate, endDate: result.endDate, startTime: result.startTime, endTime: result.endTime, priority: Int(result.priority), persons: result.persons ?? [], file: result.file)
                    tasksModel.append(taskModel)
                }
                DispatchQueue.main.async {
                    completion(tasksModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func fetchTasks(for selectedDate: Date, completion: @escaping ([TaskModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: selectedDate)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            fetchRequest.predicate = NSPredicate(format: "startDate >= %@ AND startDate < %@", startOfDay as NSDate, endOfDay as NSDate)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var tasksModel: [TaskModel] = []
                for result in results {
                    let taskModel = TaskModel(id: result.id ?? UUID(), name: result.name, info: result.info, startDate: result.startDate, endDate: result.endDate, startTime: result.startTime, endTime: result.endTime, priority: Int(result.priority), persons: result.persons ?? [], file: result.file)
                    tasksModel.append(taskModel)
                }
                DispatchQueue.main.async {
                    completion(tasksModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func saveTransaction(transactionModel: TransactionModel, completion: @escaping (Error?) -> Void) {
        let id = transactionModel.id
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let transaction: Transaction
                
                if let existingTransaction = results.first {
                    transaction = existingTransaction
                } else {
                    transaction = Transaction(context: backgroundContext)
                    transaction.id = id
                }
                
                transaction.type = Int32(transactionModel.type ?? 0)
                transaction.amount = transactionModel.amount ?? 0
                transaction.date = transactionModel.date
                transaction.info = transactionModel.info
                
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

    func fetchTransaction(completion: @escaping ([TransactionModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var transactionsModel: [TransactionModel] = []
                for result in results {
                    let transactionModel = TransactionModel(id: result.id ?? UUID(), type: Int(result.type), amount: result.amount, date: result.date, info: result.info)
                    transactionsModel.append(transactionModel)
                }
                DispatchQueue.main.async {
                    completion(transactionsModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
//    func changeTaskStatus(id: UUID, status: Int, completion: @escaping (Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//            
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                if let order = results.first {
//                    order.status = Int32(status)
//                } else {
//                    completion(NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Task not found"]))
//                }
//                try backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
//    
//    func removeTask(by id: UUID, completion: @escaping (Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//            
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                if let taskToRemove = results.first {
//                    backgroundContext.delete(taskToRemove)
//                    try backgroundContext.save()
//                    DispatchQueue.main.async {
//                        completion(nil)
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        completion(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Task not found"]))
//                    }
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
//    
//    func saveTip(tipModel: TipModel, completion: @escaping (Error?) -> Void) {
//        let id = tipModel.id
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Tip> = Tip.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//            
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                let tip: Tip
//                
//                if let existingTip = results.first {
//                    tip = existingTip
//                } else {
//                    tip = Tip(context: backgroundContext)
//                    tip.id = id
//                }
//                
//                tip.info = tipModel.info
//                tip.header = tipModel.header
//                
//                try backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
//    
//    func fetchTips(completion: @escaping ([TipModel], Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Tip> = Tip.fetchRequest()
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                var tipsModel: [TipModel] = []
//                for result in results {
//                    let tipModel = TipModel(id: result.id ?? UUID(), header: result.header, info: result.info)
//                    tipsModel.append(tipModel)
//                }
//                DispatchQueue.main.async {
//                    completion(tipsModel, nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//            }
//        }
//    }
}

