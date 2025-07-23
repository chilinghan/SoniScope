//
//  SessionSummary.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/23/25.
//

import SwiftUI

struct Constants {
    static let ColorsBlue: Color = Color(red: 0, green: 0.53, blue: 1)
    static let FillsPrimary: Color = Color(red: 0.47, green: 0.47, blue: 0.47).opacity(0.2)
}

struct SessionSummary: View {
    var body: some View {
        ZStack {
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 360, height: 137)
              .background(Color(red: 0.11, green: 0.11, blue: 0.12))
              .cornerRadius(16)
            
            Image("Rectangle 1")
              .frame(width: 402, height: 83)
              .background(Color(red: 0.07, green: 0.07, blue: 0.07))
              .offset(x:0, y:380)
            
            Text("Session Details")
                .font(.system(size: 18, weight: .medium, design: .default))
              .foregroundColor(.white)
              .offset(x:0, y:-370)
            
            Text("Edit  ")
                .font(.system(size:18, weight: .medium, design: .default))
              .multilineTextAlignment(.trailing)
              .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
              .offset(x:130, y:-370)
            
            
            Image(systemName:"square.and.arrow.up")
                .font(.system(size:18))
              .multilineTextAlignment(.trailing)
              .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
              .offset(x:170, y:-373)
            
            Text("August")
                .font(.system(size:18, weight: .medium, design: .default))
              .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
              .offset(x:-145, y:-370)
            
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 50, height: 36)
              .background(
                Image(.chevron)
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 50, height: 36)
                  .clipped()
              )
              .offset(x:-180, y:-370)
            
            Text("Jane Doe Session")
                .font(.system(size:24, weight: .bold, design: .default))
              .foregroundColor(.white)
              .offset(x:-90, y:-320)
            
            Text("Friday, Aug 1, 2025")
                .font(.system(size:18, weight: .medium, design: .default))
              .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.58))
              .offset(x:-108, y:-280)
            
            Text("from 10:45 to 10:47")
                .font(.system(size:18))
              .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.58))
              .offset(x:-108, y:-255)
            
            Text("Delete Session")
                .font(.system(size:18, weight:.bold)
              )
              .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
              .offset(x:0, y:380)
            
            Image("Rectangle 79")
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
            
            
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        .background(.black)
    }
}

#Preview {
    SessionSummary()
}
