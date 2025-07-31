//
//  ArchiveView.swift
//  SoniScope
//
//  Created by Chiling Han on 7/22/25.
//

import SwiftUI
import CoreData

struct ArchiveView: View {
    @EnvironmentObject private var accessoryManager: AccessorySessionManager
    @State private var selectedDate = Date()

    @State private var selectedSession: SessionEntity? = nil
    @State private var visibleSessionIDs: Set<NSManagedObjectID> = []

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
                        VStack(spacing: 12) {
                            ForEach(filteredSessions) { session in
                                if visibleSessionIDs.contains(session.objectID) {
                                    NavigationLink(destination: ResultsView(session: session)) {
                                        SessionRow(
                                            session: session,
                                            indicatorColor: (session.diagnosis ?? "Healthy") == "Healthy"
                                                ? Color.soniscopeBlue
                                                : .yellow
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.horizontal)
                                }
                            }

                        }
                        .padding(.bottom, 100)
                    }
                    .frame(maxHeight: 400)
                }
                
                Spacer()
            }
            .onAppear {
                accessoryManager.sendScreenCommand("home")
                populateVisible()
            }
            .onChange(of: filteredSessions) {
                populateVisible()
            }
            .background(.black)
            .ignoresSafeArea()

        }
    }
    
    func populateVisible() {
        for (index, session) in filteredSessions.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                    _ = visibleSessionIDs.insert(session.objectID)
            }
        }
    }
    
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    return ArchiveView().environment(\.managedObjectContext, context)
}
