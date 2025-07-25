import Foundation
import AccessorySetupKit
import CoreBluetooth
import SwiftUI
import Observation

@Observable
final class AccessorySessionManager: NSObject {
    // State Properties
    var rawAudio: String?
    var peripheralConnected = false
    var connectionStatus = "Disconnected"
    var showPairingError = false
    
    // BLE Properties
    private var currentAccessory: ASAccessory?
    private var session = ASAccessorySession()
    private var centralManager: CBCentralManager?
    private var peripheral: CBPeripheral?
    private var audioCharacteristic: CBCharacteristic?
    
    // UUID Configuration
    private static let serviceUUID = CBUUID(string: "180A")
    private static let audioCharUUID = CBUUID(string: "2A57")
    
    private static let soniScopeItem: ASPickerDisplayItem = {
        let descriptor = ASDiscoveryDescriptor()
        descriptor.bluetoothServiceUUID = serviceUUID
        return ASPickerDisplayItem(
            name: "SoniScope",
            productImage: UIImage(systemName: "waveform")!,
            descriptor: descriptor
        )
    }()

    override init() {
        super.init()
        session.activate(on: .main, eventHandler: handleSessionEvent)
    }
    
    func presentPicker() {
        connectionStatus = "Searching..."
        session.showPicker(for: [Self.soniScopeItem]) { error in
            if let error {
                self.connectionStatus = "Pairing Failed"
                self.showPairingError = true
                print("Pairing error: \(error.localizedDescription)")
            }
        }
    }
    
    func disconnect() {
        guard let peripheral else { return }
        centralManager?.cancelPeripheralConnection(peripheral)
    }
    
    private func handleSessionEvent(event: ASAccessoryEvent) {
        DispatchQueue.main.async {
            switch event.eventType {
            case .accessoryAdded, .accessoryChanged:
                guard let accessory = event.accessory else { return }
                self.setupAccessory(accessory)
            case .activated:
                guard let accessory = self.session.accessories.first else { return }
                self.setupAccessory(accessory)
            case .accessoryRemoved:
                self.cleanupConnection()
            default: break
            }
        }
    }
    
    private func setupAccessory(_ accessory: ASAccessory) {
        currentAccessory = accessory
        connectionStatus = "Setting up..."
        
        if centralManager == nil {
            centralManager = CBCentralManager(
                delegate: self,
                queue: .main,
                options: [CBCentralManagerOptionShowPowerAlertKey: true]
            )
        }
    }
    
    private func cleanupConnection() {
        peripheralConnected = false
        connectionStatus = "Disconnected"
        peripheral = nil
        audioCharacteristic = nil
    }
}

// MARK: - BLE Delegates
extension AccessorySessionManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            if let peripheralID = currentAccessory?.bluetoothIdentifier {
                let peripherals = central.retrievePeripherals(withIdentifiers: [peripheralID])
                if let peripheral = peripherals.first {
                    self.peripheral = peripheral
                    peripheral.delegate = self
                    central.connect(peripheral)
                }
            }
        case .poweredOff:
            connectionStatus = "Bluetooth Off"
        case .unauthorized:
            connectionStatus = "Bluetooth Unauthorized"
        default:
            connectionStatus = "Bluetooth Unavailable"
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheralConnected = true
        connectionStatus = "Discovering Services..."
        peripheral.discoverServices([Self.serviceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        cleanupConnection()
    }
}

extension AccessorySessionManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        services.forEach {
            if $0.uuid == Self.serviceUUID {
                connectionStatus = "Discovering Characteristics..."
                peripheral.discoverCharacteristics([Self.audioCharUUID], for: $0)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        characteristics.forEach {
            if $0.uuid == Self.audioCharUUID {
                audioCharacteristic = $0
                peripheral.setNotifyValue(true, for: $0)
                connectionStatus = "Connected"
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard characteristic.uuid == Self.audioCharUUID,
              let data = characteristic.value else { return }
        
        let hexString = data.map { String(format: "%02X", $0) }.joined()
        DispatchQueue.main.async {
            self.rawAudio = hexString
        }
    }
}
