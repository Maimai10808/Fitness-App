//
//  File.swift
//  FitnessApp
//
//  Created by mac on 4/9/25.
//

import Foundation
import HealthKit

class ChartsViewModel: ObservableObject {
    @Published var chartData: [DailyStepModel] = []
    private let healthManager = HealthManager.shared

    
    @Published var oneWeekAverage = 0
    @Published var oneWeekTotal = 0
    
    @Published var mockOneMonthData = [DailyStepModel]()
    @Published var oneMonthAverage = 0
    @Published var oneMonthTotal = 0
    
    @Published var mockThreeMonthData = [DailyStepModel]()
    @Published var threeMonthAverage = 0
    @Published var threeMonthTotal = 0
    
    @Published var ytdChartData = [MonthlyStepModel]()
    @Published var ytdAverage = 0
    @Published var ytdTotal = 0
    
    @Published var oneYearChartData = [MonthlyStepModel]()
    @Published var oneYearAverage = 0
    @Published var oneYearTotal = 0
    
    @Published var presentError = false
    
    
    init() {
        Task {
            do {
                // 1️⃣ 申请 HealthKit 读取权限
                try await healthManager.requestHealthKitAccess()

                // 2️⃣ 给系统一点时间完成授权（可视情况调整或去掉）
                try await Task.sleep(nanoseconds: 1_000_000_000)

                // 3️⃣ 并发抓取最近一周 / 一月 / 三月 / YTD&12个月 数据
                async let week : () = fetchOneWeekStepData()
                async let month: () = fetchOneMonthStepData()
                async let quarter = fetchThreeMonthsStepData()
                async let yearData = fetchYTDAndOneYearChartData()

                // 等待全部完成；如果任一抛错，会被 catch 捕获
                _ = try await (week, month, quarter, yearData)

            } catch {
                // 授权失败或任何抓取错误 → 弹窗提示
                await MainActor.run { self.presentError = true }
                print("Charts fetch error:", error)
            }
        }
    }
    
    func mockDataForDays(days: Int) -> [DailyStepModel] {
        let calendar = Calendar.current
        let today = Date()
        let data = (0..<days).map { offset -> DailyStepModel in
            let date = calendar.date(byAdding: .day, value: -offset, to: today) ?? today
            let randomCount = Double(Int.random(in: 5000...15000))
            return DailyStepModel(date: date, count: Int(randomCount))
        }
        return data.sorted { $0.date < $1.date }
    }
    
    // MARK: - 最近 7 天
    func fetchOneWeekStepData() async throws {
        try await withCheckedThrowingContinuation { (c: CheckedContinuation<Void, Error>) in
            healthManager.fetchWeeklySteps { [weak self] result in
                guard let self else { return c.resume(throwing: URLError(.badServerResponse)) }

                switch result {
                case .success(let weekData):
                    DispatchQueue.main.async {
                        self.chartData      = weekData.sorted { $0.date < $1.date }
                        self.oneWeekTotal   = self.chartData.reduce(0) { $0 + $1.count }
                        self.oneWeekAverage = self.oneWeekTotal / 7
                        c.resume(returning: ())
                    }
                case .failure(let error):
                    c.resume(throwing: error)
                }
            }
        }
    }

    // MARK: - 最近 30 天
    func fetchOneMonthStepData() async throws {
        try await withCheckedThrowingContinuation { (c: CheckedContinuation<Void, Error>) in
            healthManager.fetchStepData(forLast: 30) { [weak self] data in
                guard let self else { return c.resume(throwing: URLError(.badServerResponse)) }

                DispatchQueue.main.async {
                    self.mockOneMonthData = data
                    self.oneMonthTotal    = data.reduce(0) { $0 + $1.count }
                    self.oneMonthAverage  = self.oneMonthTotal / 30
                    c.resume(returning: ())
                }
            }
        }
    }

    // MARK: - 最近 90 天
    func fetchThreeMonthsStepData() async throws {
        try await withCheckedThrowingContinuation { (c: CheckedContinuation<Void, Error>) in
            healthManager.fetchStepData(forLast: 90) { [weak self] data in
                guard let self else { return c.resume(throwing: URLError(.badServerResponse)) }

                DispatchQueue.main.async {
                    self.mockThreeMonthData = data
                    self.threeMonthTotal    = data.reduce(0) { $0 + $1.count }
                    self.threeMonthAverage  = self.threeMonthTotal / 90
                    c.resume(returning: ())
                }
            }
        }
    }

    // MARK: - 年内 / 近 12 个月
    func fetchYTDAndOneYearChartData() async throws {
        try await withCheckedThrowingContinuation { (c: CheckedContinuation<Void, Error>) in
            healthManager.fetchYTDAndOneYearChartData { [weak self] result in
                guard let self else { return c.resume(throwing: URLError(.badServerResponse)) }

                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.ytdChartData     = data.ytd
                        self.oneYearChartData = data.oneYear

                        self.ytdTotal     = self.ytdChartData.reduce(0) { $0 + $1.count }
                        self.oneYearTotal = self.oneYearChartData.reduce(0) { $0 + $1.count }

                        self.ytdAverage   = self.ytdTotal / Calendar.current.component(.month, from: Date())
                        self.oneYearAverage = self.oneYearTotal / 12

                        c.resume(returning: ())
                    }
                case .failure(let error):
                    c.resume(throwing: error)
                }
            }
        }
    }
    
    
}
