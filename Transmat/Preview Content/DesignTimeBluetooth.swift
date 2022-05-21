//
//  DesignTimeBluetooth.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-09.
//

import Foundation
import Bluejay

class DesignTimeBluetooth: CommandService {
    var isConnected: Bool = false

    var isScanning: Bool = false

    var error: Error?

    func start() {
        debugPrint("start bluetooth service")
    }

    func stop() {
        debugPrint("stop bluetooth service")
    }

    func send(_ value: String) {
        debugPrint(value)
    }
}
