//
//  DateExtension.swift
//  FitnessApp
//
//  Created by mac on 4/12/25.
//

import Foundation



extension Date {
    
    static var startOfDay: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: Date())
    }
    
    static var startOfWeek: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2
        return calendar.date(from: components) ?? Date()
    }
    
    func fetchMonthStartAndEndDate() -> (Date, Date) {
        let calendar = Calendar.current
        let startDateComponent = calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self))
        let startDate = calendar.date(from: startDateComponent) ?? self
        
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) ?? self
        return (startDate, endDate)
    }
    
    func formatWorkoutDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
    
    func fetchPreviousMonday() -> Date {
            let calendar = Calendar.current
            let today = Date()

            // Get the weekday component (1 = Sunday, 2 = Monday, ..., 7 = Saturday)
            let weekday = calendar.component(.weekday, from: today)
            
            // If today is Sunday (1), return the previous Monday (subtract 6 days)
            // Otherwise, calculate the date for the Monday of the current week
            let daysToMonday = weekday == 1 ? -6 : 2 - weekday
            
            // Get the date for Monday of the current week or the previous Monday
            let monday = calendar.date(byAdding: .day, value: daysToMonday, to: today)
        
            return monday ?? Date()

        
    }
    
    
    func MondayDateFormat() -> String {
        let monday = self.fetchPreviousMonday()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: monday)
    }
    
   
    
}
