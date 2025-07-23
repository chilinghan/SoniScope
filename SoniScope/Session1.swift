//
//  Session1.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/23/25.
//


//
//  Session1.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/22/25.
//

import SwiftUI

struct Session1: View {
    var body: some View {
        ZStack {
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 482, height: 104)
              .background(Color(red: 0.11, green: 0.11, blue: 0.12))
              .offset(y:-410)
            
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 339, height: 412)
              .background(
                Image(.bodyLowRes)
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 339*1.4, height: 412*1.4)
                  .clipped()
                  
              )
              .offset(y:-110)
            
            
            ZStack {
                // Centered Title
                Text("Session")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)

                // Left-aligned End Button
                HStack(spacing: 3) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))

                    Text("End")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 50) // Ensures padding from screen edges
            .padding(.top, 10)
            .offset(y: -382)
            

            
            Circle()
                .frame(width: 25, height: 25)
                .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                .offset(x:-70, y:-230)
            
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 402, height: 423)
              .background(Color(red: 0.11, green: 0.11, blue: 0.12))
              .cornerRadius(30)
              .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: -10)
              .offset(y:220)
            
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 351, height: 45)
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
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                
                Label("Next Step", systemImage: "arrow.right")
                    .font(.system(size:18, weight: .semibold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                 
            }
            .offset(y:325)
            
            
            
            Text("Find the middle of your left torso, above your heart.")
              .font(
                  .system(size: 20, weight:.medium)
              )
              .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(60)
              .offset(y:150)
            
            
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 370, height: 1)
              .background(Color(red: 0.25, green: 0.25, blue: 0.27))
              .offset(y:85)
            
            ZStack{
                
                ZStack{
                    Circle()
                        .fill(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.56, green: 0.79, blue: 0.9), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.99, green: 0.52, blue: 0), location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0.17, y: 0.14),
                                endPoint: UnitPoint(x: 0.84, y: 1)
                            )
                        )
                        .frame(width: 32, height: 32)
                    
                    Text("1")
                        .font(
                            .system(size:20, weight: .bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(width: 15, height: 34, alignment: .center)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Text("Locate Placement Point")
                    .font(.system(size:25, weight: .bold)
                    )
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)

                
            }
            .padding(60)
            .offset( y:50)


            
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        .background(.black)
       
    }
}

#Preview {
    Session1()
}
