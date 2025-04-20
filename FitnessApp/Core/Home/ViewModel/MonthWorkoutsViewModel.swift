//
//  MonthWorkoutsViewModel.swift
//  FitnessApp
//
//  Created by mac on 4/20/25.
//

import Foundation

class MonthWorkoutsViewModel: ObservableObject {
    
    @Published var selectedMonth = 0 {
           didSet { updateSelectedDate() }   // ← 月份变化时，同步日期
       }
       @Published var selectedDate = Date()
    
    
    @Published var workouts = [Workout]()
    
    @Published var currentMonthWorkouts = [
        Workout(title: "Running", image: "figure.run", duration: "52 mins" , date: "Aug 1", calories: "512 kcal", tintColor: .green),
        Workout(title: "Running", image: "figure.run", duration: "52 mins" , date: "Aug 1", calories: "512 kcal", tintColor: .green),
        Workout(title: "Running", image: "figure.run", duration: "52 mins" , date: "Aug 1", calories: "512 kcal", tintColor: .green),
        Workout(title: "Running", image: "figure.run", duration: "52 mins" , date: "Aug 1", calories: "512 kcal", tintColor: .green)
    ]
    
    func updateSelectedDate() {
        self.selectedDate = Calendar.current.date(byAdding: .month, value: selectedMonth, to: Date()) ?? Date()
    }
    
    
}
