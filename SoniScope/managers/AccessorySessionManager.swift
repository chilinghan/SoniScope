import Foundation
import AccessorySetupKit
import CoreBluetooth
import SwiftUI
import Observation

@Observable
final class AccessorySessionManager: NSObject, ObservableObject {
    // State
    var rawAudio: String?
    var peripheralConnected = false
    var connectionStatus = "Disconnected"
    var showPairingError = false
    var audioBuffer: AudioBufferManager = AudioBufferManager()

    // BLE
    private var currentAccessory: ASAccessory?
    private var session = ASAccessorySession()
    private var centralManager: CBCentralManager?
    private var peripheral: CBPeripheral?
    private var audioCharacteristic: CBCharacteristic?
    private var screenCharacteristic: CBCharacteristic?  // New
    
    // UUIDs
    private static let audioCharUUID = CBUUID(string: "1094c6d5-cf3c-4294-bf2a-9aada4343ba0")
    private static let screenCharUUID = CBUUID(string: "1f964148-2bb7-4d92-971f-419e61ac385b")

    private static let soniScopeItem: ASPickerDisplayItem = {
        let descriptor = ASDiscoveryDescriptor()
        descriptor.bluetoothServiceUUID = AccessoryModel.soniScope.serviceUUID  // Key service for filtering
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
//        if session == nil {
//            session = ASAccessorySession(accessoryIdentifier: "YourAccessoryID")
//            session?.delegate = self
//        }
        
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
        screenCharacteristic = nil
        session.invalidate()
        session = nil
    }
}

// MARK: - CBCentralManagerDelegate

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
        peripheral.discoverServices([AccessoryModel.soniScope.serviceUUID])
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        cleanupConnection()
    }
}

// MARK: - CBPeripheralDelegate

extension AccessorySessionManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            if service.uuid == AccessoryModel.soniScope.serviceUUID {
                peripheral.discoverCharacteristics([Self.audioCharUUID], for: service)
                peripheral.discoverCharacteristics([Self.screenCharUUID], for: service)
                connectionStatus = "Connected"
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            if characteristic.uuid == Self.audioCharUUID {
                audioCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.uuid == Self.screenCharUUID {
                screenCharacteristic = characteristic
                print("✅ Screen characteristic discovered!")
            }
        }
    }


    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard characteristic.uuid == Self.audioCharUUID,
              let data = characteristic.value else { return }
        
        audioBuffer.appendAudioData(data)
        
        let hexString = data.map { String(format: "%02X", $0) }.joined()
        DispatchQueue.main.async {
            self.rawAudio = hexString
        }
    }
}

// MARK: - Send Screen Command

extension AccessorySessionManager {
    func sendScreenCommand(_ command: String) {
        print("🔧 Attempting to send command: \(command)")
        print("  ↪️ Peripheral: \(String(describing: peripheral))")
        print("  ↪️ Screen Char: \(String(describing: screenCharacteristic))")
        print("  ↪️ Central State: \(String(describing: centralManager?.state.rawValue))")
        
        guard let characteristic = self.screenCharacteristic,
              let peripheral = self.peripheral,
              peripheral.state == .connected,
              centralManager?.state == .poweredOn,
              let data = command.data(using: .utf8) else {
            print("❌ Conditions not met. Skipping BLE write.")
            return
        }
        
        print("✅ Writing BLE screen command to device")
        peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
    }
}
