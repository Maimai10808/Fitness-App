//
//  LeaderboardUser.swift
//  FitnessApp
//
//  Created by mac on 4/10/25.
//

import Foundation

struct LeaderboardUser: Codable, Identifiable {
    let id: Int
    let createdAt: String
    let username: String
    let count: Int
}
