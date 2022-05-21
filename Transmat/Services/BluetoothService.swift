//
//  BluetoothService.swift
//  Transmat
//
//  Created by Zach Smoroden on 2022-05-04.
//

import SwiftUI
import Bluejay
import CoreBluetooth

final class BluetoothService: CommandService {
    let bluejay = Bluejay()
    let service = ServiceIdentifier(uuid: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")
    lazy var characteristic = CharacteristicIdentifier(uuid: "6e400002-b5a3-f393-e0a9-e50e24dcca9e",
                                                       service: service)

    @Published var isConnected: Bool = false
    @Published var isScanning: Bool = false
    @Published var error: Error?

    init() {
        bluejay.start()
        start()
    }

    func start() {
        guard !bluejay.isScanning else { return }
        isScanning = true
        isConnected = false
        
        bluejay.scan(serviceIdentifiers: [service]) { [weak self] discovery, _ in
            guard let strongSelf = self else { return .stop }

            strongSelf.connect(discovery.peripheralIdentifier)
            return .stop
        } stopped: { [weak self] _, error in
            self?.isScanning = false

            if let error = error {
                debugPrint("Scan stopped with error: \(error.localizedDescription)")
            }
            else {
                debugPrint("Scan stopped without error.")
            }
        }
    }

    func stop() {
        bluejay.disconnect()
        isConnected = false
        isScanning = false
    }

    func send(_ value: String) {
        bluejay.write(to: characteristic, value: "\(value)\n") { [weak self] result in
            switch result {
            case .success:
                debugPrint("Sent \(value)")
            case .failure(let error):
                self?.error = error
            }
        }
    }

    private func connect(_ peripheral: PeripheralIdentifier) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.bluejay.connect(peripheral, timeout: .seconds(15)) { result in
                switch result {
                case .success:
                    withAnimation {
                        strongSelf.isConnected = true
                        strongSelf.isScanning = false
                    }
                case .failure(let error):
                    strongSelf.isConnected = false
                    strongSelf.error = error
                    strongSelf.isScanning = false
                }
            }
        }
    }
}
