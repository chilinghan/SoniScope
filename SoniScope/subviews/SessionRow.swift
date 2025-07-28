//
//  SessionRow.swift
//  SoniScope
//
//  Created by Chiling Han on 7/22/25.
//

import SwiftUI

// MARK: - Helper Functions

func formattedDate(_ date: Date?) -> String {
    guard let date = date else { return "Unknown Date" }
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
}

func formattedTime(_ date: Date?) -> String {
    guard let date = date else { return "Unknown Time" }
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter.string(from: date)
}

// MARK: - Session Row

struct SessionRow: View {
    let session: SessionEntity

    var indicatorColor: Color {
        session.diagnosis == "Healthy"
        ? Color(red: 0.56, green: 0.79, blue: 0.9)
        : .yellow
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    ZStack {}
                        .frame(width: 4, height: 24)
                        .background(indicatorColor)
                        .cornerRadius(100)

                    Text(session.name ?? "Untitled")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()

                    Text(formattedDate(session.timestamp))
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.57))
                }

                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.37))
                        Text(formattedTime(session.timestamp))
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.37))
                    }

                    Text(" ")

                    HStack(spacing: 4) {
                        Image(systemName: "timer")
                            .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.37))
                        Text("0:20 min")
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
