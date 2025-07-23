//
//  StartView.swift
//  SoniScope
//
//  Created by Praise Durojaiye on 7/22/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedDate = Date()

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date()).uppercased()
    }
    
    var body: some View {
        VStack {
            // Top bar
            HStack {
                VStack(alignment: .leading) {
                    Text(formattedDate)
                        .foregroundColor(.gray)
                        .font(.caption)
                    Text("SoniScope")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Image(systemName: "person.circle")
                    .font(.system(size: 30))
                    .foregroundColor(.orange)
            }
            .padding(.horizontal)
            .padding(.top, 80)
            
            Spacer()
            
            // Button
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

                 Rectangle()
                     .frame(width: 360, height: 52)
                     .foregroundColor(.clear)
                     .cornerRadius(10)

                 HStack {
                     Text("Pair SoniScope")
                         .font(.system(size: 18, weight: .semibold))
                     
                     Spacer()
                                          
                     Image(systemName: "chevron.right")
                         .font(.system(size: 18, weight: .semibold))
                 }
                 .foregroundColor(.black)
                 .frame(width: 320, height: 52)

             }
             .padding(.bottom, 250)

            
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .top)
        .background(.black)

    }
    
}


#Preview {
    HomeView()
}
