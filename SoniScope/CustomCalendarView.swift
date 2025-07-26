//
//  CustomCalendarView.swift
//  SoniScope
//
//  Created by Chiling Han on 7/22/25.
//


import SwiftUI

struct CustomCalendarView: View {
    @State private var displayedMonth: Date = Date()
    @Binding var selectedDate: Date
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

    var body: some View {
        VStack (spacing: 12) {
            // MARK: Header with Month and Arrows
            HStack {
                Text(monthYearString(from: displayedMonth))
                    .font(Font.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth)!
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(red: 142/255, green: 202/255, blue: 229/255, opacity: 1))
                        .font(.system(size: 20, weight: .medium))
                    
                }
                
                Button(action: {
                    displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth)!
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(red: 142/255, green: 202/255, blue: 229/255, opacity: 1))
                        .font(.system(size: 20, weight: .medium))
                    
                }
            }
            .padding(.top, 9)
            .padding(.horizontal, 30)
            
            // MARK: Day of Week Headers
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(Font.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.37))
                }
            }
            .padding(.horizontal, 25)
            
            // MARK: Date Grid
            let gridItems = Array(repeating: GridItem(.flexible(minimum: 40)), count: 7)
            LazyVGrid(columns: gridItems, spacing: 10) {
                ForEach(generateDatesForMonth(), id: \.self) { date in
                    dateCell(for: date)
                        .frame(height: 30)
                }
            }
            .padding(.horizontal, 25)

        }
        .padding(.top, 16)
        .padding(.bottom, 16)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.2))
                .shadow(radius: 5)
        )
        .frame(maxWidth: 370)
    }
        
    // MARK: - Date Cell View
    @ViewBuilder
    private func dateCell(for date: Date?) -> some View {
        // Define a consistent height for all cells
        let cellHeight: CGFloat = 50 // You can adjust this value as needed
        
        if let date = date {
            let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
            
            ZStack {
                // Background Circle for selected/today dates
                Circle()
                    .fill(isSelected ? Color(red: 0.56, green: 0.79, blue: 0.9) :
                          Color.clear)
                
                // Date number text
                Text("\(calendar.component(.day, from: date))")
                    .font(.body) // Explicitly set font for consistent text size
                    .foregroundColor(isSelected ? .black : .white)
            }
            .frame(maxWidth: .infinity, minHeight: cellHeight) // Apply consistent height to the ZStack
            .contentShape(Rectangle()) // Make the entire frame tappable
            .onTapGesture {
                selectedDate = date
            }
        } else {
            // Empty cell placeholder to maintain grid structure
            Text("")
                .frame(maxWidth: .infinity, minHeight: cellHeight) // Ensure empty cells also have the same height
        }
    }

    // MARK: - Helper: Dates for Month Grid
    private func generateDatesForMonth() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
              let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday else {
            return []
        }

        var dates: [Date?] = []
        
        // 1. Leading empty cells to align first day
        let leadingEmptyCells = (firstWeekday - 1 + 7) % 7 // 0-6 range
        dates.append(contentsOf: Array(repeating: nil, count: leadingEmptyCells))

        // 2. Dates for current month
        var current = monthInterval.start
        while current < monthInterval.end {
            dates.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }

        // 3. Fill trailing cells with next month's dates until total is 42
        let totalCells = 42
        let trailingEmptyCells = totalCells - dates.count
        if trailingEmptyCells > 0 {
            // Start from next month first day
            guard let nextMonthStart = calendar.date(byAdding: .month, value: 1, to: monthInterval.start) else {
                return dates
            }
            var nextMonthDate = nextMonthStart
            for _ in 0..<trailingEmptyCells {
                dates.append(nextMonthDate)
                nextMonthDate = calendar.date(byAdding: .day, value: 1, to: nextMonthDate)!
            }
        }

        return dates
    }


    // MARK: - Helper: Month-Year Format
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    CustomCalendarView(selectedDate: .constant(Date()))
}
