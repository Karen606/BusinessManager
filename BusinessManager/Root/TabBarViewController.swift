//
//  TabBarViewController.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 16.12.24.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: .homeTab.withRenderingMode(.alwaysOriginal), tag: 0)
    
        let promptrVC = TasksViewController(nibName: "TasksViewController", bundle: nil)
        promptrVC.tabBarItem = UITabBarItem(title: "Tasks", image: .tasksTab.withRenderingMode(.alwaysOriginal), tag: 1)

        let calendarVC = CalendarViewController(nibName: "CalendarViewController", bundle: nil)
        calendarVC.tabBarItem = UITabBarItem(title: "Calendar", image: .calendarTab.withRenderingMode(.alwaysOriginal), tag: 2)

        let financeVC = FinanceViewController(nibName: "FinanceViewController", bundle: nil)
        financeVC.tabBarItem = UITabBarItem(title: "Finance", image: .financeTab.withRenderingMode(.alwaysOriginal), tag: 3)
        
        let contactVC = ContactViewController(nibName: "ContactViewController", bundle: nil)
        contactVC.tabBarItem = UITabBarItem(title: "Contact", image: .contactTab.withRenderingMode(.alwaysOriginal), tag: 3)
        self.viewControllers = [UINavigationController(rootViewController: homeVC), UINavigationController(rootViewController: promptrVC), UINavigationController(rootViewController: calendarVC), UINavigationController(rootViewController: financeVC), UINavigationController(rootViewController: contactVC)]

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
