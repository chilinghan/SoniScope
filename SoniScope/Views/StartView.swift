//
//  StartView.swift
//  SoniScope
//
//  Created by Praise Durojaiye on 7/22/25.
//

import SwiftUI

struct StartView: View {
    @State private var navigateToSession1 = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.black
                    .frame(width: 402, height: 902)
                    .cornerRadius(44)
                
                ZStack {
                    LinearGradient(
                        stops: [
                            .init(color: Color(red: 0.56, green: 0.79, blue: 0.9), location: 0.00),
                            .init(color: Color(red: 0.99, green: 0.52, blue: 0), location: 1.00),
                        ],
                        startPoint: .bottomTrailing,
                        endPoint: .topLeading
                    )
                    .frame(width: 290, height: 52)
                    .cornerRadius(60)
                    
                    Image("Rectangle 63")
                        .resizable()
                        .frame(width: 360, height: 52)
                        .cornerRadius(10)
                    
                    Text("▶︎")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .offset(x:-60)
                    
                    Text("Start Session")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .offset(x:10)
                    
                    Text("SoniScope")
                        .font(.system(size: 37, weight: .bold))
                        .foregroundColor(Color(red: 0.96, green: 1, blue: 0.98))
                        .offset(x:-100, y:-540)
                    
                    Text("FRIDAY, AUG 1")
                        .font(.custom("SF Pro", size: 14).weight(.medium))
                        .foregroundColor(.gray)
                        .offset(x:-138, y:-572)
                }
                .offset(y: 220)
                .onTapGesture {
                    navigateToSession1 = true
                }
                
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
                    .font(.custom("SF Pro", size: 11).weight(.medium))
                    .foregroundColor(.gray)
                    .offset(x: 70, y: 410)
                
                Text("Home")
                    .font(.custom("SF Pro", size: 11).weight(.medium))
                    .foregroundColor(.gray)
                    .offset(x:-68, y: 410)
                
                // Navigate to Session1
                NavigationLink(destination: Session1(), isActive: $navigateToSession1) {
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    StartView()
}
