//
//  NotificationManager.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 18.12.24.
//


import UserNotifications
import UIKit

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    DispatchQueue.main.async {
                        completion(granted)
                    }
                }
            case .denied:
                DispatchQueue.main.async {
                    self.showSettingsAlert()
                    completion(false)
                }
            case .authorized, .provisional:
                DispatchQueue.main.async {
                    completion(true)
                }
            case .ephemeral:
                completion(false)
            @unknown default:
                completion(false)
            }
        }
    }
    
    // MARK: - Show Settings Alert
    private func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Enable Notifications",
            message: "Please enable notifications in Settings to receive alerts.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        })
        
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func scheduleNotification(for event: EventModel) {
        guard let startDate = event.startDate, let reminderIndex = event.reminder else {
            print("Missing required event data to schedule a notification.")
            return
        }
        
        let reminderOffsets: [Int] = [15, 30, 60, 120, 240]
        guard reminderIndex >= 0 && reminderIndex < reminderOffsets.count else {
            print("Invalid reminder index.")
            return
        }
        
        let offsetMinutes = reminderOffsets[reminderIndex]
        guard let triggerDate = Calendar.current.date(byAdding: .minute, value: -offsetMinutes, to: startDate) else {
            print("Failed to calculate trigger date.")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "\(event.startDate?.toString(format: "HH:mm") ?? ""): \(EventType.allCases[event.event ?? 0].rawValue)"
        content.body = "\(event.place ?? "")\n\(event.info ?? "")"
        content.sound = .default
        
        let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: event.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled for \(triggerDate) with ID: \(event.id.uuidString)")
            }
        }
    }
}
