//
//  Bluejay+Transmat.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-09.
//

import Foundation
import Bluejay

extension Bluejay {
    func connectAsync(_ peripheralIdentifier: PeripheralIdentifier,
                      timeout: Timeout = .none,
                      warningOptions: WarningOptions? = nil) async -> ConnectionResult {
        await withCheckedContinuation { continuation in
            connect(peripheralIdentifier, timeout: timeout, warningOptions: warningOptions) {                continuation.resume(returning: $0)
            }
        }
    }
}
