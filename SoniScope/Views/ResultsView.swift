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
                .offset(y: -410)
            
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
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 24))
                    .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 50)
            .padding(.top, 10)
            .offset(y: -382)
            
            
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 360, height: 137)
              .background(Color(red: 0.11, green: 0.11, blue: 0.12))
              .cornerRadius(16)
           
            
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 360, height: 132)
              .background(Color(red: 0.11, green: 0.11, blue: 0.12))
              .cornerRadius(16)
              .offset(x:0, y:-150)
            
            
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 360, height: 88)
              .background(Color(red: 0.11, green: 0.11, blue: 0.12))
              .cornerRadius(16)
              .offset(x:0, y:130)
            
            Label("Healthy", systemImage: "checkmark.circle.fill")
            .font(.system(size:18, weight:.medium))
              .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
              .offset(x:-125, y:-200)
            
            
            Text("Notes")
              .font(
                .system(size:18, weight: .semibold)
              )
              .foregroundColor(.white)
              .offset(x:-140, y:110)
            
            Text("Recording")
              .font(.system(size:18, weight: .semibold)
              )
              .foregroundColor(.white)
              .offset(x:-125,y:-50)
            
            Text("Write notes here..")
              .font(.system(size:18))
              .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.58))
              .offset(x:-94,y:135)
            
            Text("This recording does not show signs of lung disease. SoniScope can not provide a formal diagnosis.")
                .font(.system(size:18))
              .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.58))
              .frame(width: 334, alignment: .leading)
              .offset(x:0, y:-150)
            
            
            
            Image(systemName:"waveform.circle")
              .font(
                Font.custom("SF Pro", size: 28)
                  .weight(.semibold)
              )
              .multilineTextAlignment(.trailing)
              .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
              .offset(x:155,y:-50)
            
            Text("00:11")
              .font(.system(size:12, weight: .semibold)
              )
              .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.37))
              .offset(x:-120, y:30)
            
            Text("00:20")
              .font(
                .system(size:12, weight: .semibold)
              )
              .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.37))
              .offset(x:120, y:30)
            
            ZStack {
                HStack(alignment: .center, spacing: 0) { HStack(alignment: .center, spacing: 0) { ZStack {}
                        .frame(width: 6, height: 6)
                        .background(Constants.ColorsBlue)
                        .cornerRadius(3)}
                        .padding(.leading, 0)
                        .padding(.trailing, 262)
                        .padding(.vertical, 0)
                        .frame(width: 268, height: 6, alignment: .leading)
                        .background(Constants.FillsPrimary)
                        .cornerRadius(3)}
                .padding(.horizontal, 16)
                .padding(.vertical, 0)
                .frame(width: 300, height: 44, alignment: .center)
                .offset(x:0, y:15)
                
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 145, height: 6)
                  .background(
                    LinearGradient(
                      stops: [
                        Gradient.Stop(color: Color(red: 0.99, green: 0.52, blue: 0), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.56, green: 0.79, blue: 0.9), location: 1.00),
                      ],
                      startPoint: UnitPoint(x: 0, y: 0.5),
                      endPoint: UnitPoint(x: 1, y: 0.5)
                    )
                  )
                  .cornerRadius(3)
                  .offset(x:-62, y:15)
            }
            .frame(width: 300, height: 44)
            
            
            Image(systemName: "play.circle")
              .font(
                Font.custom("SF Pro", size: 24)
                  .weight(.bold)
              )
              .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
              .offset(x:-150, y:15)
            
            Image(systemName: "speaker.wave.2.circle")
              .font(
                Font.custom("SF Pro", size: 24)
                  .weight(.bold)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
              .offset(x:150, y:15)
            ZStack{
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 360, height: 54)
                  .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                  .cornerRadius(16)
                
                Text("Jane Doe Session")
                    .font(.system(size:18))
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding(80)
            }
            .offset(y:-300)
            
            ZStack{
                
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 360, height: 54)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(16)
                
                Text("Delete Session")
                    .font(.system(size: 18, weight: .semibold))
                  .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                
            }
            .offset(y:250)
            
            
            
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        .background(.black)
    }
    
}
