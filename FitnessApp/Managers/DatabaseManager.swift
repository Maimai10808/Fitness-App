//
//  DatabaseManager.swift
//  FitnessApp
//
//  Created by mac on 4/12/25.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    let database = Firestore.firestore()
    let weeklyLeaderboard = "\(Date().MondayDateFormat())-leaderboard"
    
    // Fetch Leaderboards
    func fetchLeaderboards() async throws {
        let snapshot = try await database.collection("groups").getDocuments()
        
        print(snapshot.documents)
        print(snapshot.documents.first?.data())
    }
    
    // Post (Update) Leaderboards for current user
    func postStepCountUpdateFor(username: String, count: Int) async throws {
        let leader = LeaderboardUser(username: username, count: count)
        let data = try Firestore.Encoder().encode(leader)
        
        try await database.collection(weeklyLeaderboard).document(username).setData(data, merge: false)
    }
    
    
}




