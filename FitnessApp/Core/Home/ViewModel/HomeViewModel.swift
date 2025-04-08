//
//  HomeViewModel.swift
//  FitnessApp
//
//  Created by mac on 4/3/25.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    
    let healthManager = HealthManager.shared
    
    
    @Published var calories: Int = 0
    @Published var exercise: Int = 0
    @Published var stand   : Int = 0
    @Published var steps: Int = 0
    @Published var workouts = [Workout]()
    
    var mockActivites = [
        Activity(id: 1, title: "Today steps", subtitle: "Goal 12,000", image: "figure.walk", tintColor: .green, amount: "9812"),
        Activity(id: 2, title: "Today steps", subtitle: "Goal 12,000", image: "figure.walk", tintColor: .blue, amount: "9812"),
        Activity(id: 3, title: "Today steps", subtitle: "Goal 12,000", image: "figure.walk", tintColor: .yellow, amount: "9812"),
        Activity(id: 4, title: "Today steps", subtitle: "Goal 12,000", image: "figure.walk", tintColor: .pink, amount: "9812")
        
    ]
    
    var mockWorkouts = [
        Workout(id: 0, title: "Running", image: "figure.run", duration: "52 mins" , date: "Aug 1", calories: "512 kcal", tintColor: .green),
        Workout(id: 1, title: "Running", image: "figure.run", duration: "52 mins" , date: "Aug 1", calories: "512 kcal", tintColor: .blue),
        Workout(id: 2, title: "Running", image: "figure.run", duration: "52 mins" , date: "Aug 1", calories: "512 kcal", tintColor: .yellow),
        Workout(id: 3, title: "Running", image: "figure.run", duration: "52 mins" , date: "Aug 1", calories: "512 kcal", tintColor: .pink),
    ]
    
    init() {
        Task {
            do {
                try await healthManager.requestHealthKitAccess()
                // Wait a short moment to ensure authorization is complete
                try await Task.sleep(nanoseconds: 1_000_000_000)
                await MainActor.run {
                    fetchTodayCalories()
                    fetchTodayExerciseTime()
                    fetchTodayStandHour()
                    fetchTodaySteps()
                    fetchRecentWorkouts()
                }
            } catch {
                print("HealthKit authorization error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchTodayCalories() {
        healthManager.fetchTodayCaloriesBurned { result in
            switch result {
            case .success(let calories):
                DispatchQueue.main.async {
                    self.calories = Int(calories)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
                
            }
        }
    }
    
    func fetchTodayExerciseTime() {
        healthManager.fetchTodayExerciseTime { result in
            switch result {
            case .success(let exercise):
                DispatchQueue.main.async {
                    self.exercise = Int(exercise)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
                
            }
        }
    }
    
    func fetchTodayStandHour() {
        healthManager.fetchTodayStandHours { result in
            switch result {
            case .success(let hours):
                DispatchQueue.main.async {
                    self.stand = Int(hours)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
                
            }
        }
    }
    
    func fetchTodaySteps() {
        healthManager.fetchTodaysSteps { result in
            switch result {
            case .success(let steps):
                DispatchQueue.main.async {
                    self.steps = Int(steps)
                }
            case .failure(let failure):
                print("Steps fetch error: \(failure.localizedDescription)")
            }
        }
    }
    
    func fetchRecentWorkouts() {
        healthManager.fetchWorkoutsForMonth(month: Date()) { result in
            switch result {
            case .success(let workouts):
                DispatchQueue.main.async {
                    self.workouts = Array(workouts.prefix(4))
                }
            case .failure(let failure):
                print("Workouts fetch error: \(failure.localizedDescription)")
            }
            
        }
    }
    
    
    
}
    
    /*
     
     
    
    
*/
