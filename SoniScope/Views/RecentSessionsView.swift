//
//  RecentSessionsView.swift
//  YourAppName
//
//  Created by Chiling Han on 7/22/25.
//

import SwiftUI

// MARK: - Session Model

struct Session: Identifiable {
    let id = UUID()
    let title: String
    let date: Date          // Session start date & time
    let duration: TimeInterval // Duration in seconds
}

// MARK: - Sample Data

extension Session {
    static let sampleSessions: [Session] = [
        Session(title: "Healthy", date: Date().addingTimeInterval(-3600 * 6), duration: 65), // 6 hrs ago, 1 hr
        Session(title: "Healthy", date: Date().addingTimeInterval(-3600 * 2), duration: 84), // 2 hrs ago, 30 min
        
        Session(title: "Healthy", date: Date(), duration: 72), // yesterday 9AM, 2hr
        
        Session(title: "Healthy", date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!.addingTimeInterval(3600 * 12), duration: 93), // 3 days ago 12PM, 1.5hr
    ]
}

// MARK: - Helpers for Formatting
func dateString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
}

func timeString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter.string(from: date)
}

func durationString(from interval: TimeInterval) -> String {
    let minutes = Int(interval) / 60
    let seconds = Int(interval) % 60
    if seconds == 0 {
        return "\(minutes) min"
    } else {
        return String(format: "%d:%02d min", minutes, seconds)
    }
}

// MARK: - Grouping Extension

extension Array where Element == Session {
    func groupedByDate() -> [(date: Date, sessions: [Session])] {
        let groupedDict = Dictionary(grouping: self) { session -> Date in
            Calendar.current.startOfDay(for: session.date)
        }
        
        return groupedDict
            .map { ($0.key, $0.value) }
            .sorted { $0.0 > $1.0 } // descending date order
    }
}

// MARK: - Session Row View

struct SessionRow: View {
    let session: Session
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    ZStack { }
                    .frame(width: 4, height: 24, alignment: .top)
                    .background(Color(red: 0.56, green: 0.79, blue: 0.9))
                    .cornerRadius(100)
                    
                    Text(session.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(dateString(from: session.date))
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.57))
                                         
                }
                
                HStack(spacing: 12) {
                    HStack (spacing: 4) {
                        Image(systemName: "clock")
                            .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.37))

                        Text(timeString(from: session.date))
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.37))
                    }
                    
                    Text(" ")
                        .foregroundColor(.gray)
                    
                    HStack (spacing: 4) {
                        Image(systemName: "timer")
                            .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.37))
                        
                        Text(durationString(from: session.duration))
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.37))
                    }
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        .cornerRadius(20)
    }
}

// MARK: - Recent Sessions View

struct RecentSessionsView: View {
    let sessions: [Session]
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(sessions.groupedByDate(), id: \.date) { group in
                        ForEach(group.sessions) { session in
                            SessionRow(session: session)
                                .padding(.horizontal)
                        }
                }
            }
            .padding(.top)
            .padding(.bottom, 60)
        }
    }
    
    func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

// MARK: - Preview

struct RecentSessionsView_Previews: PreviewProvider {
    static var previews: some View {
        RecentSessionsView(sessions: Session.sampleSessions)
    }
}
