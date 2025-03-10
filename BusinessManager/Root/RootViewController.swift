//
//  ViewController.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 16.12.24.
//

import UIKit
import FirebaseRemoteConfig
import WebKit

class RootViewController: UIViewController {
    private var remoteConfig: RemoteConfig!
    private var privacyWebViewController: PrivacyWebViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFirstLaunch() {
            if !NetworkManager.shared.isConnected {
                showAlert("No network connection available")
            }
        }
        
        if let savedUrl = (UIApplication.shared.delegate as? AppDelegate)?.getSavedUrl() {
            loadWebView(with: savedUrl, showAgreeButton: false)
        } else if isFirstLaunch() {
            initializeRemoteConfig()
        } else {
            if let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "TabBarController") {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = tabBarVC
                    window.makeKeyAndVisible()
                }
            }
        }
    }
    
    private func loadWebView(with urlString: String, showAgreeButton: Bool) {
        privacyWebViewController = PrivacyWebViewController()
        privacyWebViewController?.currentUrlString = urlString
        privacyWebViewController?.navigationItem.hidesBackButton = true
        privacyWebViewController?.showAgreeButton = showAgreeButton
        privacyWebViewController?.completion = { [weak self] in
            guard let self = self else { return }
            if let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "TabBarController") {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = tabBarVC
                    window.makeKeyAndVisible()
                }
            }
        }
        self.navigationController?.pushViewController(privacyWebViewController!, animated: true)
    }
    
    private func initializeRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600
        remoteConfig.configSettings = settings
        fetchRemoteConfigLink()
    }
    
    private func fetchRemoteConfigLink() {
        remoteConfig.fetchAndActivate { [weak self] status, error in
            guard error == nil else {
                print("Failed to fetch RemoteConfig: \(error!)")
                return
            }
            
            if let privacyLink = self?.remoteConfig["privacyLink"].stringValue, !privacyLink.isEmpty {
                self?.loadWebView(with: privacyLink, showAgreeButton: true)
            } else {
                print("Privacy link is empty in RemoteConfig.")
            }
        }
    }

    private func isFirstLaunch() -> Bool {
        return !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Network Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
