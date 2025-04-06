//
//  HealthManager.swift
//  FitnessApp
//
//  Created by mac on 4/3/25.
//

import Foundation
import HealthKit


extension Date {
    
    static var startOfDay: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: Date())
    }
}

class HealthManager {
    
    static let shared = HealthManager()
    
    let healthStore = HKHealthStore()
    
    private init() {
        
        
        Task {
            do {
                try await requestHealthKitAccess()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
      
    
    func requestHealthKitAccess() async throws {
        let calories = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand = HKQuantityType(.appleStandTime)
        let steps = HKQuantityType(.stepCount)
        let workouts = HKSampleType.workoutType()
        
        let healthTypes: Set = [calories, exercise, stand, steps, workouts]
        
        try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
    }
    
    func fetchTodayCaloriesBurned(completion: @escaping(Result<Double, Error>) -> Void) {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error occurred"])))
                return
            }
            
            guard let quantity = results?.sumQuantity() else {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No stand data available"])))
                return
            }
            
            let calorieCount = quantity.doubleValue(for: .kilocalorie())
            completion(.success(calorieCount))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayExerciseTime(completion: @escaping(Result<Double, Error>) -> Void) {
        let exercise = HKQuantityType(.appleExerciseTime)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: exercise, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error occurred"])))
                return
            }
            
            guard let quantity = results?.sumQuantity() else {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No stand data available"])))
                return
            }
            
            let exerciseCount = quantity.doubleValue(for: .minute())
            completion(.success(exerciseCount))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayStandHours(completion: @escaping(Result<Int, Error>) -> Void) {
        let stand = HKQuantityType(.appleStandTime)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: stand, quantitySamplePredicate: predicate) { _, results, error in
            if let error = error {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error: \(error.localizedDescription)"])))
                return
            }
            
            guard let quantity = results?.sumQuantity() else {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No stand data available"])))
                return
            }
            
            print("Stand data: \(quantity.doubleValue(for: .minute())) minutes")
            let standCount = Int(quantity.doubleValue(for: .minute()) / 60) // Convert minutes to hours
            completion(.success(standCount))
        }
        
        healthStore.execute(query)
    }
    
    func fetchCurrentWeekoutStats(completion: @escaping(Result<[Activity], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate,  limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, error in
            guard let workouts = results as? [HKWorkout], let self = self, error == nil else {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error occurred"])))
                return
            }
            
            var runningCount: Int = 0
            var strengthCount: Int = 0
            var soccerCount: Int = 0
            var basketballCount: Int = 0
            var stairsCount: Int = 0
            var kickboxingCount: Int = 0
            
            for workout in workouts {
                let duration = Int(workout.duration)/60
                if workout.workoutActivityType == .running {
                    runningCount += duration
                } else if workout.workoutActivityType == .traditionalStrengthTraining {
                    strengthCount += duration
                } else if workout.workoutActivityType == .soccer {
                    soccerCount += duration
                } else if workout.workoutActivityType == .basketball {
                    basketballCount += duration
                } else if workout.workoutActivityType == .stairClimbing {
                    stairsCount += duration
                } else if workout.workoutActivityType == .kickboxing {
                    kickboxingCount += duration
                }
            }
            
            completion(.success(self.generateActivitiesFromDurations(running: runningCount, strengthstrength: strengthCount, soccer: soccerCount, basketball: basketballCount, stairs: stairsCount, kickboxing: kickboxingCount)))
        }
        
        healthStore.execute(query)
        
    }
    
    func generateActivitiesFromDurations(running: Int, strengthstrength: Int, soccer: Int, basketball: Int, stairs: Int, kickboxing: Int) -> [Activity] {
        return [
            Activity(title: "Running", subtitle: "Goal 12,000", image: "figure.run", tintColor: .green, amount: "\(running)"),
            Activity(title: "Strength Training", subtitle: "Goal 12,000", image: "figure.strengthtraining.traditional", tintColor: .blue, amount: "\(strengthstrength)"),
            Activity(title: "Soccer", subtitle: "Goal 12,000", image: "figure.indoor.soccer", tintColor: .yellow, amount: "\(soccer)"),
            Activity(title: "Basketball", subtitle: "Goal 12,000", image: "figure.basketball", tintColor: .pink, amount: "\(basketball)"),
            Activity(title: "Stairs", subtitle: "Goal 12,000", image: "figure.stairs", tintColor: .pink, amount: "\(stairs)"),
            Activity(title: "Kickboxing", subtitle: "Goal 12,000", image: "ffigure.kickboxing", tintColor: .pink, amount: "\(kickboxing)")
        ]
    }
    
    func fetchTodaysSteps() {
        
    }
   
}
