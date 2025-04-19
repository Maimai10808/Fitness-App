//
//  LeaderboardUser.swift
//  FitnessApp
//
//  Created by mac on 4/10/25.
//

import Foundation

struct LeaderboardUser: Codable, Identifiable {
    let id = UUID()
    let username: String
    let count: Int
}

struct LeaderboardResult {
    let user: LeaderboardUser?
    let top10: [LeaderboardUser]
}
