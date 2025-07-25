//
//  ArchiveView.swift
//  SoniScope
//
//  Created by Chiling Han on 7/22/25.
//
import SwiftUI

class SessionStore: ObservableObject {
    @Published var sessions: [Session] = Session.sampleSessions
}

struct ArchiveView: View {
    @State private var selectedDate = Date()
    @EnvironmentObject var sessionStore: SessionStore

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date()).uppercased()
    }
    
    var body: some View {
        VStack(spacing: 10) {
            // Top bar
            HStack {
                VStack {
                    Text(formattedDate)
                        .foregroundColor(.gray)
                        .font(.caption)
                    Text("Archive")
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

            
            CustomCalendarView(selectedDate: $selectedDate)
                .padding()
            
            HStack {
                Text("Recent Sessions")
                    .font(Font.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.top)
                Spacer()
            }
            
            // Filter sessions for selected date
            let sessionsForDate = sessionStore.sessions.filter {
                Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
            }
            
            if sessionsForDate.isEmpty {
                Text("No sessions on this date.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                RecentSessionsView(sessions: sessionsForDate)
                    .frame(maxHeight: 300) // limit height as needed
            }
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .top)
        .background(.black)

    }
}

#Preview{
    ArchiveView()
}
