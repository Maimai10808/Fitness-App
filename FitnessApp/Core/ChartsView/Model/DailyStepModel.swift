//
//  File.swift
//  FitnessApp
//
//  Created by mac on 4/9/25.
//

import Foundation

struct DailyStepModel: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

struct MonthlyStepModel: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}

enum ChartOptions: String, CaseIterable {
    case oneWeek = "1W"
    case oneMonth = "1M"
    case threeMonth = "3M"
    case yearToDate = "YTD"
    case oneYear = "1Y"
}
