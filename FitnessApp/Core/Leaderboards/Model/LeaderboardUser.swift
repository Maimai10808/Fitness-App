//
//  LeaderboardUser.swift
//  FitnessApp
//
//  Created by mac on 4/10/25.
//

import Foundation

struct LeaderboardUser: Codable, Identifiable {
    var id = UUID()
    let username: String
    let count: Int
}
