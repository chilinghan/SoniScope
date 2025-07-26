//
//  AccessoryModel.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/14/25.
//
import Foundation
import CoreBluetooth
import UIKit

enum AccessoryModel {
    case soniScope
    
    var accessoryName: String {
        switch self {
            case .soniScope: "Respify SoniScope"
        }
    }
    
    var displayName: String {
        switch self {
            case .soniScope: "SoniScope"
        }
    }
    
    var serviceUUID: CBUUID {
        switch self {
            case .soniScope: CBUUID(string: "93ae16d8-749c-4f7c-846c-dd4776f76676")
        }
    }
    
    var accessoryImage: UIImage {
        switch self {
        case .soniScope: .image
        }
    }
}
