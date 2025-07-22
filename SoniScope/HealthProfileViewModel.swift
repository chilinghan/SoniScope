//
//  HealthProfileViewModel.swift
//  SoniScope
//
//  Created by Chiling Han on 7/21/25.
//


import Foundation
import HealthKit

class HealthProfileViewModel: ObservableObject {
    private var healthStore = HKHealthStore()
    
    @Published var dateOfBirth: String = "Not available"
    @Published var biologicalSex: String = "Not available"
    @Published var bloodType: String = "Not available"
    
    init() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let readTypes: Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
            HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
            HKObjectType.characteristicType(forIdentifier: .bloodType)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.loadProfile()
                }
            } else {
                print("HealthKit authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    private func loadProfile() {
        do {
            let dob = try healthStore.dateOfBirthComponents()
            let sex = try healthStore.biologicalSex().biologicalSex
            let blood = try healthStore.bloodType().bloodType
            
            // Format and publish
            if let year = dob.year, let month = dob.month, let day = dob.day {
                self.dateOfBirth = "\(year)-\(month)-\(day)"
            }
            
            self.biologicalSex = {
                switch sex {
                case .male: return "Male"
                case .female: return "Female"
                case .other: return "Other"
                case .notSet: fallthrough
                @unknown default: return "Not set"
                }
            }()
            
            self.bloodType = {
                switch blood {
                case .aPositive: return "A+"
                case .aNegative: return "A-"
                case .bPositive: return "B+"
                case .bNegative: return "B-"
                case .abPositive: return "AB+"
                case .abNegative: return "AB-"
                case .oPositive: return "O+"
                case .oNegative: return "O-"
                case .notSet: fallthrough
                @unknown default: return "Not set"
                }
            }()
            
        } catch {
            print("Error loading profile: \(error.localizedDescription)")
        }
    }
}
