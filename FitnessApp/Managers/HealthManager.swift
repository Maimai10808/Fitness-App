//
//  HealthManager.swift
//  FitnessApp
//
//  Created by mac on 4/3/25.
//

import Foundation
import HealthKit

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
            if let error = error {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error: \(error.localizedDescription)"])))
                return
            }
            
            guard let quantity = results?.sumQuantity() else {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No calories data available"])))
                return
            }
            
            let calorieCount = quantity.doubleValue(for: .kilocalorie())
            print("Calories data: \(calorieCount) kcal")
            completion(.success(calorieCount))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayExerciseTime(completion: @escaping(Result<Double, Error>) -> Void) {
        let exercise = HKQuantityType(.appleExerciseTime)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: exercise, quantitySamplePredicate: predicate) { _, results, error in
            if let error = error {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error: \(error.localizedDescription)"])))
                return
            }
            
            guard let quantity = results?.sumQuantity() else {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No exercise data available"])))
                return
            }
            
            let exerciseCount = quantity.doubleValue(for: .minute())
            print("Exercise data: \(exerciseCount) minutes")
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
    
    // MARK: Recent Workouts
    func fetchWorkoutsForMonth(month: Date, completion: @escaping (Result<[Workout], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let (startDate, endDate) = month.fetchMonthStartAndEndDate()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, results, error in
            guard let workouts = results as? [HKWorkout], error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let workoutsArray = workouts.map( { Workout(title: $0.workoutActivityType.name, image: $0.workoutActivityType.image, duration: "\(Int($0.duration) / 60 ) mins", date: $0.startDate.formatWorkoutDate(), calories: $0.totalEnergyBurned?.doubleValue(for: .kilocalorie()).formatted() ?? "-", tintColor: $0.workoutActivityType.color)})
            
            completion(.success(workoutsArray))
        }
        healthStore.execute(query)
    }
    
    func fetchTodaysSteps(completion: @escaping(Result<Double, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            if let error = error {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error: \(error.localizedDescription)"])))
                return
            }
            
            guard let quantity = results?.sumQuantity() else {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No steps data available"])))
                return
            }
            
            let stepsCount = quantity.doubleValue(for: .count())
            print("Steps data: \(stepsCount) steps")
            completion(.success(stepsCount))
        }
        
        healthStore.execute(query)
    }
    
    func fetchWeeklySteps(completion: @escaping(Result<[DailyStepModel], Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKStatisticsCollectionQuery(
            quantityType: steps,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: .startOfWeek,
            intervalComponents: DateComponents(day: 1)
        )
        
        query.initialResultsHandler = { query, results, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let results = results else {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No step data available"])))
                return
            }
            
            var dailySteps: [DailyStepModel] = []
            
            results.enumerateStatistics(from: .startOfWeek, to: Date()) { statistics, _ in
                if let quantity = statistics.sumQuantity() {
                    let steps = quantity.doubleValue(for: .count())
                    dailySteps.append(DailyStepModel(date: statistics.startDate, count: Int(steps)))
                }
            }
            
            completion(.success(dailySteps))
        }
        
        healthStore.execute(query)
    }
   
}

extension HealthManager {
    
    struct YearchartDataResult {
        let ytd: [MonthlyStepModel]
        let oneYear: [MonthlyStepModel]
    }
    
    func fetchYTDAndOneYearChartData(completion: @escaping (Result<YearchartDataResult, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let calendar = Calendar.current
        
        var oneYearMonths = [MonthlyStepModel]()
        var ytdMonths = [MonthlyStepModel]()
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.fitnessapp.healthdata", qos: .userInitiated)
        
        for i in 0...11 {
            group.enter()
            queue.async {
                let month = calendar.date(byAdding: .month, value: -i, to: Date()) ?? Date()
                let (startOfMonth, endOfMonth) = month.fetchMonthStartAndEndDate()
                
                let predicate = HKQuery.predicateForSamples(withStart: startOfMonth, end: endOfMonth)
                
                let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
                    defer { group.leave() }
                    
                    if let error = error {
                        print("Error fetching steps for month \(month): \(error.localizedDescription)")
                        return
                    }
                    
                    guard let quantity = results?.sumQuantity() else {
                        print("No step data available for month \(month)")
                        return
                    }
                    
                    let stepCount = quantity.doubleValue(for: .count())
                    let monthModel = MonthlyStepModel(date: startOfMonth, count: Int(stepCount))
                    
                    queue.async {
                        oneYearMonths.append(monthModel)
                        
                        // Check if this month is in the current year for YTD data
                        if calendar.component(.year, from: month) == calendar.component(.year, from: Date()) {
                            ytdMonths.append(monthModel)
                        }
                    }
                }
                
                self.healthStore.execute(query)
            }
        }
        
        group.notify(queue: queue) {
            // Sort the arrays by date
            oneYearMonths.sort { $0.date < $1.date }
            ytdMonths.sort { $0.date < $1.date }
            
            completion(.success(YearchartDataResult(ytd: ytdMonths, oneYear: oneYearMonths)))
        }
    }
    
    // 从 HealthKit 中获取今天的步数数据。
    // 注意：传入的参数 fetchCurrentWeekStepCount 实际上作为 completion handler 使用，
    // 建议统一更名为 completion 以提高代码可读性。
    func fetchCurrentWeekStepCount(completion: @escaping (Result<Double, Error>) -> Void) {
        // 创建表示步数的 HKQuantityType 对象
        let steps = HKQuantityType(.stepCount)
        
        // 构建时间谓词，用于限定查询时间范围：从今天零时到当前时刻
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        
        // 创建一个统计查询，统计符合条件的步数样本数据的总和
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            // 如果查询过程中发生错误，则调用 completion handler 并返回错误信息
            if let error = error {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [
                    NSLocalizedDescriptionKey: "Error: \(error.localizedDescription)"
                ])))
                return
            }
                    
            // 从查询结果中获取总步数数据；如果结果为空，则返回错误
            guard let quantity = results?.sumQuantity() else {
                completion(.failure(NSError(domain: "com.yourdomain.app", code: 0, userInfo: [
                    NSLocalizedDescriptionKey: "No steps data available"
                ])))
                return
            }
                    
            // 将获取到的步数数据转换为 Double 类型
            let steps = quantity.doubleValue(for: .count())
            
            // 打印步数数据到控制台，方便调试
            print("Steps data: \(steps) steps")
            
            // 通过 completion handler 返回步数数据
            completion(.success(steps))
        }
                
        // 将创建的查询交给 HealthKit 的 healthStore 执行
        healthStore.execute(query)
    }
    
    
}

    
