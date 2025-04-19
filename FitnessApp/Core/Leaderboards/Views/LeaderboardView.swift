//
//  LeaderboardView.swift
//  FitnessApp
//
//  Created by mac on 4/10/25.
//

import SwiftUI
import Foundation

struct LeaderboardView: View {
    @AppStorage("username") var username: String?
    
    @StateObject var viewModel = LeaderboardViewModel()
        
    @Binding var showTerms: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Text("Leaderboard")
                    .font(.largeTitle)
                    .bold()
                
                HStack {
                    Text("Name")
                        .bold()
                    
                    Spacer()
                    
                    Text("Steps")
                        .bold()
                }
                .padding()
                
                ScrollView {
                    LazyVStack(spacing: 24) {
                        // 显示前10名用户
                        ForEach(Array(viewModel.leaderResult.top10.enumerated()), id: \.element.id) { (idx, person) in
                            HStack {
                                Text("\(idx + 1).")
                                    .frame(width: 30)
                                
                                Text(person.username)
                                
                                if idx == 0 {
                                    Image(systemName: "crown.fill")
                                        .foregroundStyle(.yellow)
                                }
                                
                                Spacer()
                                
                                Text("\(person.count)")
                            }
                            .padding(.horizontal)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        // 显示其他用户
                        if let user = viewModel.leaderResult.user {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .foregroundStyle(.gray.opacity(0.5))
                                .padding(.vertical)
                            
                            HStack {
                                Text(user.username)
                                Spacer()
                                Text("\(user.count)")
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            if showTerms {
                Color.white
                
                TermsView(showTerms: $showTerms)
            }
            
        }
        .onChange(of: showTerms) { _ in
            if !showTerms && username != nil {
                Task {
                    do {
                        try await viewModel.setupLeaderboardData()
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
        }
    }
}

#Preview {
    LeaderboardView(showTerms: .constant(false))
}
