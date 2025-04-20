//
//  HomeViewModel.swift
//  FitnessApp
//
//  Created by mac on 4/3/25.
//

import Foundation
import SwiftUI

//  HomeViewModel.swift
import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {

    private let healthManager = HealthManager.shared

    // MARK: - Published
    @Published var calories   = 0
    @Published var exercise   = 0
    @Published var stand      = 0
    @Published var steps      = 0
    @Published var activities: [Activity] = []
    @Published var workouts  : [Workout]  = []
    @Published var presentError = false

    // MARK: - Init
    init() {
        Task {
            do {
                // 1️⃣ 申请权限
                try await healthManager.requestHealthKitAccess()
                // 2️⃣ 等待授权真正生效
                try await Task.sleep(nanoseconds: 1_000_000_000)

                // 3️⃣ 逐项拉数据
                async let fetchCalories: () = try await fetchTodayCalories()
                async let fetchExercise: () = try await fetchTodayExerciseTime()
                async let fetchStand: () = try await fetchTodayStandHour()
                async let fetchSteps: () = try await fetchTodaySteps()
                async let fetchWorkouts: () = try await fetchRecentWorkouts()
                async let fetchActivities: () = try await fetchCurrentWeekActivities()
                
                let (_, _, _, _, _, _) = (try await fetchCalories, try await  fetchExercise, try await fetchStand, try await fetchSteps, try await fetchWorkouts, try await fetchActivities)

            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.presentError = true
                }
            }
        }
    }

    // MARK: - 今日卡路里
    func fetchTodayCalories() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            healthManager.fetchTodayCaloriesBurned { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let kcal):
                    DispatchQueue.main.async {
                        self.calories = Int(kcal)
                        self.activities.append(
                            Activity(title: "Calories Burned",
                                     subtitle: "flame",
                                     image: "flame",
                                     tintColor: .red,
                                     amount: kcal.formatted())
                        )
                        continuation.resume(returning: ())
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.activities.append(
                            Activity(title: "Calories Burned",
                                     subtitle: "today",
                                     image: "flame",
                                     tintColor: .red,
                                     amount: "---")
                        )
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    // MARK: - 今日运动时间
    func fetchTodayExerciseTime() async throws {
        try await withCheckedThrowingContinuation { (c: CheckedContinuation<Void, Error>) in
            healthManager.fetchTodayExerciseTime { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let minutes):
                    DispatchQueue.main.async {
                        self.exercise = Int(minutes)
                        c.resume(returning: ())
                    }
                case .failure(let error):
                    c.resume(throwing: error)
                }
            }
        }
    }

    // MARK: - 今日站立小时
    func fetchTodayStandHour() async throws {
        try await withCheckedThrowingContinuation { (c: CheckedContinuation<Void, Error>) in
            healthManager.fetchTodayStandHours {  [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let hours):
                    DispatchQueue.main.async {
                        self.stand = Int(hours)
                        c.resume(returning: ())
                    }
                case .failure(let error):
                    c.resume(throwing: error)
                }
            }
        }
    }

    // MARK: - 今日步数
    func fetchTodaySteps() async throws {
        try await withCheckedThrowingContinuation { (c: CheckedContinuation<Void, Error>) in
            healthManager.fetchTodaysSteps {  [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let stepDbl):
                    DispatchQueue.main.async {
                        let stepInt = Int(stepDbl)
                        self.steps = stepInt
                        self.activities.append(
                            Activity(title: "Today Steps",
                                     subtitle: "Goal: 800",
                                     image: "figure.walk",
                                     tintColor: .green,
                                     amount: stepInt.formatted())
                        )
                        c.resume(returning: ())
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.activities.append(
                            Activity(title: "Today Steps",
                                     subtitle: "Goal: 800",
                                     image: "figure.walk",
                                     tintColor: .green,
                                     amount: "---")
                        )
                        c.resume(throwing: error)
                    }
                }
            }
        }
    }

    // MARK: - 当周各运动类型时长
    func fetchCurrentWeekActivities() async throws {
        try await withCheckedThrowingContinuation { (c: CheckedContinuation<Void, Error>) in
            healthManager.fetchCurrentWeekoutStats {  [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let acts):
                    DispatchQueue.main.async {
                        self.activities.append(contentsOf: acts)
                        c.resume(returning: ())
                    }
                case .failure(let error):
                    c.resume(throwing: error)
                }
            }
        }
    }

    // MARK: - 近月锻炼记录（取 4 条）
    func fetchRecentWorkouts() async throws {
        try await withCheckedThrowingContinuation { (c: CheckedContinuation<Void, Error>) in
            healthManager.fetchWorkoutsForMonth(month: Date()) {  [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let wos):
                    DispatchQueue.main.async {
                        self.workouts = Array(wos.prefix(4))
                        c.resume(returning: ())
                    }
                case .failure(let error):
                    c.resume(throwing: error)
                }
            }
        }
    }
}
