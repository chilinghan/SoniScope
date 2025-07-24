//
//  ResultsView.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/23/25.
//

import SwiftUI

struct ResultsView: View {
    var onFinish: () -> Void
    
    var body: some View {
        ZStack {
            // Background elements
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 482, height: 104)
                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                .offset(y: -400)
            
            // Header
            ZStack {
                Text("Results")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                // Left-aligned Home Button
                HStack(spacing: 3) {
                    Button(action: {
                        onFinish()  // Call onFinish when tapped
                    }) {
                        HStack(spacing: 3) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                            
                            Text("Home")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 24))
                    .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 50)
            .padding(.top, 10)
            .offset(y: -370)
            
            
            ZStack {
                VStack(spacing: 16) {
                    
                    // 🟠 Header
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 360, height: 132)
                            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Healthy", systemImage: "checkmark.circle.fill")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                                .offset(x: -10)
                            
                            Text("This recording does not show signs of lung disease. SoniScope cannot provide a formal diagnosis.")
                                .font(.system(size: 18))
                                .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.58))
                                .frame(width: 334, alignment: .leading)
                        }
                        .padding()
                        .offset(y: -10)
                    }
                    .offset(y: -50)
                    
                    // 🟡 Notes Section
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
                            .frame(width: 360, height: 88)
                        
                        VStack(alignment: .leading) {
                            Text("Notes")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Write notes here..")
                                .font(.system(size: 18))
                                .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.58))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                    .offset(y: -40)
                    
                    // 🟢 Recording Section
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
                            .frame(width: 360, height: 137)
                        
                        VStack {
                            HStack {
                                Text("Recording")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "waveform.circle")
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                            }
                            .padding(.horizontal)
                            
                            Spacer()
                            
                            HStack {
                                Text("00:11")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.37))
                                Spacer()
                                Text("00:20")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.37))
                            }
                            .padding(.horizontal)
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
                                    .frame(height: 6)
                                
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.99, green: 0.52, blue: 0),
                                        Color(red: 0.56, green: 0.79, blue: 0.9)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .frame(width: 145, height: 6)
                                .cornerRadius(3)
                            }
                            .padding(.horizontal)
                            
                            HStack {
                                Image(systemName: "play.circle")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                                Spacer()
                                Image(systemName: "speaker.wave.2.circle")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                    
                    // 🔵 Session Info
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
                            .frame(width: 360, height: 54)
                        
                        Text("Jane Doe Session")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                    }
                    .offset(y: -10)
                    
                    // 🔴 Delete Button
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
                            .frame(width: 360, height: 54)
                        
                        Text("Delete Session")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                    }
                    .offset(y: 10)
                    
                    Spacer()
                }
                .padding(.top)
            }

        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
        
    }
}
