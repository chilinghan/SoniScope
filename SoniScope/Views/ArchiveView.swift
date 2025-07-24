//
//  ArchiveView.swift
//  SoniScope
//
//  Created by Chiling Han on 7/22/25.
//
import SwiftUI


struct ArchiveView: View {
    @State private var selectedDate = Date()
    @State private var sessions: [Session] = Session.sampleSessions

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date()).uppercased()
    }
    
    var body: some View {
        VStack {
            // Top bar
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(formattedDate)
                        .foregroundColor(.gray)
                        .font(.caption)
                    Text("Logs")
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
            let sessionsForDate = sessions.filter {
                Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
            }
            
            if sessionsForDate.isEmpty {
                Text("No sessions on this date.")
                    .foregroundColor(.gray)
                    .padding(.vertical, 20)
            } else {
                RecentSessionsView(sessions: sessionsForDate)
                    .frame(maxHeight: 150) // limit height as needed
            }
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .top)
        .background(Color.black)
        .ignoresSafeArea()

    }
}

#Preview{
    ArchiveView()
}
