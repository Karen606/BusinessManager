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
    
    func saveEvent(eventModel: EventModel, completion: @escaping (Error?) -> Void) {
        let id = eventModel.id
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let event: Event
                
                if let existingEvent = results.first {
                    event = existingEvent
                } else {
                    event = Event(context: backgroundContext)
                    event.id = id
                }
                
                event.event = Int32(eventModel.event ?? 0)
                event.startDate = eventModel.startDate
                event.endDate = eventModel.endDate
                event.info = eventModel.info
                event.place = eventModel.place
                event.reminder = Int32(eventModel.reminder ?? 0)
                event.category = Int32(eventModel.category ?? 0)
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

    func fetchEvents(completion: @escaping ([EventModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var eventsModel: [EventModel] = []
                for result in results {
                    let eventModel = EventModel(id: result.id ?? UUID(), event: Int(result.event), startDate: result.startDate, endDate: result.endDate, place: result.place, info: result.info, reminder: Int(result.reminder), category: Int(result.category))
                    eventsModel.append(eventModel)
                }
                DispatchQueue.main.async {
                    completion(eventsModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func fetchEvents(for selectedDate: Date, completion: @escaping ([EventModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: selectedDate)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            fetchRequest.predicate = NSPredicate(format: "startDate >= %@ AND startDate < %@", startOfDay as NSDate, endOfDay as NSDate)
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                
                var eventsModel: [EventModel] = []
                for result in results {
                    let eventModel = EventModel(id: result.id ?? UUID(), event: Int(result.event), startDate: result.startDate, endDate: result.endDate, place: result.place, info: result.info, reminder: Int(result.reminder), category: Int(result.category))
                    eventsModel.append(eventModel)
                }
                DispatchQueue.main.async {
                    completion(eventsModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func saveContact(contactModel: ContactModel, completion: @escaping (Error?) -> Void) {
        let id = contactModel.id
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let contact: Contact
                
                if let existingContact = results.first {
                    contact = existingContact
                } else {
                    contact = Contact(context: backgroundContext)
                    contact.id = id
                }
                
                contact.name = contactModel.name
                contact.surname = contactModel.surname
                contact.email = contactModel.email
                contact.phone = contactModel.phone
                contact.tags = contactModel.tags
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

    func fetchContacts(completion: @escaping ([ContactModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var contactsModel: [ContactModel] = []
                for result in results {
                    let contactModel = ContactModel(id: result.id ?? UUID(), name: result.name, surname: result.surname, email: result.email, phone: result.phone, tags: result.tags)
                    contactsModel.append(contactModel)
                }
                DispatchQueue.main.async {
                    completion(contactsModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
}

