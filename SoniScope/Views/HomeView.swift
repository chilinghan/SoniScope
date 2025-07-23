//
//  HomeView.swift
//  SoniScope
//
//  Created by Praise Durojaiye on 7/22/25.
//

import SwiftUI

struct HomeView: View {
    @Bindable var accessoryManager: AccessorySessionManager
    @State private var navigateToStartView = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .frame(width: 402, height: 902)
                    .cornerRadius(44)

                // Gradient button + text + image
                ZStack {
                    LinearGradient(
                        stops: [
                            .init(color: Color(red: 0.56, green: 0.79, blue: 0.9), location: 0.00),
                            .init(color: Color(red: 0.99, green: 0.52, blue: 0.0), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.25, y: -0.41),
                        endPoint: UnitPoint(x: 0.77, y: 1.52)
                    )
                    .frame(width: 360, height: 52)
                    .cornerRadius(10)

                    Image("Rectangle 63")
                        .resizable()
                        .frame(width: 360, height: 52)
                        .cornerRadius(10)

                    Text(">")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .offset(x:160)

                    Text("Pair SoniScope")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .offset(x:-100)

                    Text("SoniScope")
                        .font(.system(size: 37, weight: .bold))
                        .foregroundColor(Color(red: 0.96, green: 1, blue: 0.98))
                        .offset(x:-100, y:-540)

                    Text("FRIDAY, AUG 1")
                        .font(Font.custom("SF Pro", size: 14).weight(.medium))
                        .foregroundColor(Color(red: 0.54, green: 0.54, blue: 0.54))
                        .offset(x:-138, y:-572)
                }
                .onTapGesture {
                    accessoryManager.presentPicker()
                }
                .offset(y: 220)

                // Bottom bar
                Image("Rectangle 45")
                    .resizable()
                    .frame(width: 402, height: 83)
                    .background(Color(red: 0.07, green: 0.07, blue: 0.07))
                    .offset(y: 390)

                Image(.orangelungs)
                    .resizable()
                    .frame(width: 56, height: 45)
                    .offset(x: -70, y: 385)

                Image(.archive)
                    .resizable()
                    .frame(width: 45, height: 30)
                    .offset(x: 70, y: 385)

                Text("Archive")
                    .font(Font.custom("SF Pro", size: 11).weight(.medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.52, green: 0.52, blue: 0.53))
                    .offset(x: 70, y: 410)

                Text("Home")
                    .font(Font.custom("SF Pro", size: 11).weight(.medium))
                    .foregroundColor(Color(red: 0.52, green: 0.52, blue: 0.53))
                    .multilineTextAlignment(.center)
                    .offset(x:-68, y: 410)

                // Connection status
                if accessoryManager.connectionStatus != "Disconnected" {
                    Text(accessoryManager.connectionStatus)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .offset(y: 290)
                }

                // NavigationLink to StartView
                NavigationLink(destination: StartView(), isActive: $navigateToStartView) {
                    EmptyView()
                }
                .hidden()
            }
            .onChange(of: accessoryManager.connectionStatus) { newStatus in
                if newStatus == "Connected" {
                    navigateToStartView = true
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView(accessoryManager: AccessorySessionManager())
}
