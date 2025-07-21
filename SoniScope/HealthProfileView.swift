//
//  HealthProfileView.swift
//  SoniScope
//
//  Created by Chiling Han on 7/21/25.
//


import SwiftUI

struct HealthProfileView: View {
    @StateObject private var viewModel = HealthProfileViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Personal Information")) {
                    HStack {
                        Text("Date of Birth")
                        Spacer()
                        Text(viewModel.dateOfBirth)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Biological Sex")
                        Spacer()
                        Text(viewModel.biologicalSex)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Blood Type")
                        Spacer()
                        Text(viewModel.bloodType)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("My Health Profile")
        }
    }
}
