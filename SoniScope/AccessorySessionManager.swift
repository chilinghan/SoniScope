//
//  AccessorySessionManager.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/14/25.
//

import Foundation
import AccessorySetupKit
import CoreBluetooth
import SwiftUI

@Observable
class AccessorySessionManager: NSObject {
    
    var accesoryModel: AccessoryModel?
    var rawAudio: String? = nil
    
    var peripheralConnected = false
    var pickerDismissed = true
    
    var goalTime: Double = 0.0
    var progress: CGFloat = 0.0
    var accessoryPaired: Bool = false
    
    private var currentAccessory: ASAccessory?
    private var session = ASAccessorySession()
    private var manager: CBCentralManager?
    private var peripheral: CBPeripheral?
    private var audioCharacteristic: CBCharacteristic?
    
    private static let audioCharacteristicUUID = "0000FFE1-0000-1000-8000-00805F9B34FB" // Replace with your UUID

    private static let soniScope: ASPickerDisplayItem = {
        let descriptor = ASDiscoveryDescriptor()
        descriptor.bluetoothServiceUUID = AccessoryModel.soniScope.serviceUUID
        
        return ASPickerDisplayItem(
            name: AccessoryModel.soniScope.displayName,
            productImage: AccessoryModel.soniScope.accessoryImage,
            descriptor: descriptor
        )
    }()
    
    // MARK: - AccessorySessionManager actions
    
    func removeAccessory() {
        guard let currentAccessory else { return }
        
        if peripheralConnected {
            disconnect()
        }
        
        session.removeAccessory(currentAccessory) { _ in
            self.accesoryModel = nil
            self.currentAccessory = nil
            self.manager = nil
        }
    }
    
    func connect() {
        guard let manager, manager.state == .poweredOn, let peripheral else {
            return
        }
        manager.connect(peripheral)
    }
    
    func disconnect() {
        guard let peripheral, let manager else { return }
        manager.cancelPeripheralConnection(peripheral)
    }
    
    // MARK: - Accessory Management
    
    private func saveAccessory(accessory: ASAccessory) {
        UserDefaults.standard.set(true, forKey: "accessoryPaired")
        accessoryPaired = true
        currentAccessory = accessory
        
        if manager == nil {
            manager = CBCentralManager(delegate: self, queue: nil)
        }
        
        if accessory.displayName == AccessoryModel.soniScope.displayName {
            accesoryModel = .soniScope
        }
    }
    
    private func handleSessionEvent(event: ASAccessoryEvent) {
        switch event.eventType {
        case .accessoryAdded, .accessoryChanged:
            guard let accessory = event.accessory else { return }
            saveAccessory(accessory: accessory)
        case .activated:
            guard let accessory = session.accessories.first else { return }
            saveAccessory(accessory: accessory)
        case .accessoryRemoved:
            self.accesoryModel = nil
            self.currentAccessory = nil
            self.manager = nil
        case .pickerDidPresent:
            pickerDismissed = false
        case .pickerDidDismiss:
            pickerDismissed = true
        default:
            print("Received event type \(event.eventType)")
        }
    }
}

// MARK: - CBCentralManagerDelegate
extension AccessorySessionManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central manager state: \(central.state)")
        switch central.state {
        case .poweredOn:
            if let peripheralUUID = currentAccessory?.bluetoothIdentifier {
                peripheral = central.retrievePeripherals(withIdentifiers: [peripheralUUID]).first
                peripheral?.delegate = self
                print("Retrieved peripheral: \(peripheralUUID)")
            }
        default:
            peripheral = nil
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral)")
        guard let accesoryModel else { return }
        peripheral.delegate = self
        peripheral.discoverServices([accesoryModel.serviceUUID])
        peripheralConnected = true
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from peripheral: \(peripheral)")
        peripheralConnected = false
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to peripheral: \(peripheral), error: \(error?.localizedDescription ?? "Unknown error")")
    }
}
// MARK: - CBPeripheralDelegate
extension AccessorySessionManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil, let services = peripheral.services else {
            print("Service discovery failed: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        for service in services {
            peripheral.discoverCharacteristics(
                [CBUUID(string: Self.audioCharacteristicUUID)],
                for: service
            )
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil, let characteristics = service.characteristics else {
            print("Characteristic discovery failed: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        for characteristic in characteristics {
            if characteristic.uuid == CBUUID(string: Self.audioCharacteristicUUID) {
                audioCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard characteristic.uuid == CBUUID(string: Self.audioCharacteristicUUID),
              error == nil,
              let data = characteristic.value else {
            print("Failed to read audio data")
            return
        }

        var rawMeasurements = data.map { String(format: "%02x", $0) }.joined()
        rawMeasurements = String(rawMeasurements.suffix(2)) + String(rawMeasurements.prefix(2))
        print("New audio data received: \(rawMeasurements)")

        DispatchQueue.main.async {
            withAnimation {
                self.rawAudio = rawMeasurements
            }
        }
    }
}
