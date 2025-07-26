//
//  ArchiveView.swift
//  SoniScope
//
//  Created by Chiling Han on 7/22/25.
//

import SwiftUI
import CoreData

struct ArchiveView: View {
    @State private var selectedDate = Date()

    @State private var selectedSession: SessionEntity? = nil

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SessionEntity.timestamp, ascending: false)],
        animation: .default
    ) private var allSessions: FetchedResults<SessionEntity>

    private var filteredSessions: [SessionEntity] {
        allSessions.filter {
            guard let ts = $0.timestamp else { return false }
            return Calendar.current.isDate(ts, inSameDayAs: selectedDate)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // Top bar
                HeaderView(title: "Logs")
                
                CustomCalendarView(selectedDate: $selectedDate)
                
                HStack {
                    Text("Recent Sessions")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.top)
                    Spacer()
                }
                
                if filteredSessions.isEmpty {
                    Text("No sessions on this date.")
                        .foregroundColor(.gray)
                        .padding(.vertical, 30)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredSessions) { session in
                                NavigationLink(destination: ResultsView(session: session)) {
                                    SessionRow(session: session)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 100)
                    }
                    .frame(maxHeight: 400)
                }
                
                Spacer()
            }
            .background(.black)
            .ignoresSafeArea()

        }
        }
    
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    return ArchiveView().environment(\.managedObjectContext, context)
}
