//
//  LeaderboardViewModel.swift
//  FitnessApp
//
//  Created by mac on 4/11/25.
//


import SwiftUI
import Foundation

@MainActor                    // 👈 让整个类默认运行在主执行域
final class LeaderboardViewModel: ObservableObject {
    
    @Published var showAlert      = false
    @Published var leaderResult   = LeaderboardResult(user: nil, top10: [])
    
    // MARK: - Life cycle
    init() {
        setupLeaderboardData()
    }
    
    // MARK: - Public async helper
    /// 包装真正的加载流程；自己 catch 错误 → 更新 UI
    func setupLeaderboardData() {
        Task {
            do {
                try await postStepCountUpdateForUser()
                leaderResult = try await fetchLeaderboards()     // ← 拼写也修正
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.showAlert = true
                }
            }
        }
        
        // MARK: - Data layer
        func fetchLeaderboards() async throws -> LeaderboardResult {
            let leaders = try await DatabaseManager.shared.fetchLeaderboards()
            let top10   = Array(leaders.sorted { $0.count > $1.count }.prefix(10))
            
            if let stored = UserDefaults.standard.string(forKey: "username")?.lowercased(),
               let currentUser = leaders.first(where: { $0.username.lowercased() == stored }) {
                return LeaderboardResult(user: currentUser, top10: top10)
            } else {
                return LeaderboardResult(user: nil, top10: top10)
            }
        }
        
        func postStepCountUpdateForUser() async throws {
            guard let username = UserDefaults.standard.string(forKey: "username") else {
                throw URLError(.badURL)      // 自定义更合适的错误也行
            }
            let steps = try await fetchCurrentWeekStepCount()
            try await DatabaseManager.shared
                .postStepCountUpdateFor(leader: LeaderboardUser(username: username,
                                                                count: Int(steps)))
        }
        
        func fetchCurrentWeekStepCount() async throws -> Double {
            try await withCheckedThrowingContinuation { cont in
                HealthManager.shared.fetchCurrentWeekStepCount { result in
                    cont.resume(with: result)
                }
            }
        }
    }
}
