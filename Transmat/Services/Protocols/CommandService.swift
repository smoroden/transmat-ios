//
//  CommandService.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-09.
//

import Foundation

protocol CommandService: ObservableObject {
    /// If a  device is currently connected
    var isConnected: Bool { get }
    /// If the app is trying to find a device
    var isScanning: Bool { get }
    /// The error that occured
    var error: Error? { get }

    /// Start the service
    func start()
    /// Stop the service
    func stop()
    /// Send the value to the service
    /// - Parameter value: The value to send
    func send(_ value: String)
}
