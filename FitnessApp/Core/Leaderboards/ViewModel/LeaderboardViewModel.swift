//
//  LeaderboardViewModel.swift
//  FitnessApp
//
//  Created by mac on 4/11/25.
//

import SwiftUI
import Foundation

class LeaderboardViewModel: ObservableObject {
    
    @Published var leaderResult = LeaderboardResult(user: nil, top10: [])
    
    init() {
        Task {
            do {
                try await setupLeaderboardData()

            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func setupLeaderboardData() async throws {
        try await postStepCountUpdateForUser()
        let result = try await fetchLeaerboards()
        DispatchQueue.main.async {
            self.leaderResult = result
        }
    }
    
    // fetch
    private func fetchLeaerboards() async throws -> LeaderboardResult {
        let leaders = try await DatabaseManager.shared.fetchLeaderboards()
        print("Leaders data: \(leaders)")
        
        // 排序并获取前10
        let top10 = Array(leaders.sorted(by: { $0.count > $1.count }).prefix(10))
        let username = UserDefaults.standard.string(forKey: "username")
        print("Stored username: \(String(describing: username))")
        
        // 确保比较时忽略大小写
        if let username = username?.lowercased() {
            // 查找所有用户而不仅仅是top10
            let user = leaders.first(where: { $0.username.lowercased() == username })
            print("Found user: \(String(describing: user?.username))")
            return LeaderboardResult(user: user, top10: top10)
        } else {
            print("No user data found")
            return LeaderboardResult(user: nil, top10: top10)
        }
    }
    // update
    private func postStepCountUpdateForUser() async throws {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            throw URLError(.badURL)
        }
        let steps = try await fetchCurrentWeekStepCount()
        try await DatabaseManager.shared.postStepCountUpdateFor(leader: LeaderboardUser(username: username, count: Int(steps)))
    }
    
    
    private func fetchCurrentWeekStepCount() async throws -> Double {
        try await withCheckedThrowingContinuation({ continuation in
            HealthManager.shared.fetchCurrentWeekStepCount { result in
                continuation.resume(with: result)
            }
        })
    }
    
    var mockData = [
        LeaderboardUser(username: "jason", count: 4124),
        LeaderboardUser(username: "you", count: 4532),
        LeaderboardUser(username: "seanallen", count: 3432),
        LeaderboardUser(username: "paul hudson", count: 5678),
        LeaderboardUser(username: "catalin", count: 6896),
        LeaderboardUser(username: "robin", count: 2345),
        LeaderboardUser(username: "logan", count: 5675),
        LeaderboardUser(username: "jason", count: 4124),
        LeaderboardUser(username: "you", count: 4532),
        LeaderboardUser(username: "seanallen", count: 3432),
        LeaderboardUser( username: "paul hudson", count: 5678),
        LeaderboardUser( username: "catalin", count: 6896),
        LeaderboardUser( username: "robin", count: 2345),
        LeaderboardUser( username: "logan", count: 5675)
    ]
    
}
