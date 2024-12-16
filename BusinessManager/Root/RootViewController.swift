//
//  ViewController.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 16.12.24.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "TabBarController") {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = tabBarVC
                window.makeKeyAndVisible()
            }
        }
    }
}

