//
//  NetworkManager.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 10.01.25.
//


import Network

class NetworkManager {
    static let shared = NetworkManager()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    var isConnected: Bool = false
    private init() {}

    func checkConnection() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = (path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
}
