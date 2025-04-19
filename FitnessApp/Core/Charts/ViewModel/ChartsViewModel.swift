//
//  File.swift
//  FitnessApp
//
//  Created by mac on 4/9/25.
//

import Foundation

class ChartsViewModel: ObservableObject {
    @Published var chartData: [DailyStepModel] = []
    private let healthManager = HealthManager.shared

    @Published var mockWeekChartData = [
        DailyStepModel(date: Date(), count: 12315),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(), count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date(), count: 9775),
    ]
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
    
    
    init() {
        // 生成最近 30 天 和 90 天的数据
        let oneMonth = mockDataForDays(days: 30)
        let threeMonth = mockDataForDays(days: 90)
        
        DispatchQueue.main.async {
            self.mockOneMonthData = oneMonth
            self.mockThreeMonthData = threeMonth
        }
        
        fetchWeeklySteps()
        fetchYTDAndOneYearChartData()
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
    
    func fetchWeeklySteps() {
        healthManager.fetchWeeklySteps { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let steps):
                    self?.chartData = steps
                case .failure(let error):
                    print("Error fetching weekly steps: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchYTDAndOneYearChartData() {
        healthManager.fetchYTDAndOneYearChartData { result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.ytdChartData = result.ytd
                    self.oneYearChartData = result.oneYear
                    
                    self.ytdTotal = self.ytdChartData.reduce(0, { $0 + $1.count})
                    self.oneYearTotal = self.oneYearChartData.reduce(0, { $0 + $1.count})
                    
                    self.ytdAverage = self.ytdTotal / Calendar.current.component(.month, from: Date())
                    self.oneYearAverage = self.oneYearTotal / 12
                }
            case .failure(let error):
                print("Error fetching YTDAndOneYearChartData : \(error.localizedDescription)")
            }
            
        }
    }
    
    
}
