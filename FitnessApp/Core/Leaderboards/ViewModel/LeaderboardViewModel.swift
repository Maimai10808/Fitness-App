//
//  LeaderboardViewModel.swift
//  FitnessApp
//
//  Created by mac on 4/11/25.
//

import SwiftUI
import Foundation

class LeaderboardViewModel: ObservableObject {
    
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
