//
//  HeaderView.swift
//  SoniScope
//
//  Created by Chiling Han on 7/24/25.
//


import SwiftUI

struct HeaderView: View {
    let title: String
    @ObservedObject var healthData = HealthDataManager()
    @State private var showHealthCard = false
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date()).uppercased()
    }

    var body: some View {
        HStack (alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedDate)
                    .foregroundColor(.gray)
                    .font(.caption)
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button {
                showHealthCard.toggle()
            } label: {
                Image(systemName: "person.circle")
                    .font(.system(size: 30))
                    .foregroundColor(.orange)
                
            }
        }
        .padding(.horizontal)
        .padding(.top, 80)
        .sheet(isPresented: $showHealthCard) {
            HealthDetailCardView(healthData: healthData)
                .presentationDetents([.fraction(0.75)])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    HeaderView(title: "Logs")
}
