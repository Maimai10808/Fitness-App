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
                ZStack(alignment: .trailing) {
                    Text("Leaderboard")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity)
                    
                    Button {
                        viewModel.setupLeaderboardData()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .scaledToFit()
                            .bold()
                            .foregroundStyle(Color(uiColor: .label))
                            .frame(width: 28, height: 28)
                            .padding(.trailing)
                    }
                }
                
                
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
            .alert("Oops",
                   isPresented: $viewModel.showAlert) {
                // ✅ 用 Button 才能点
                Button("OK", role: .cancel) {
                    viewModel.showAlert = false   // 也可以留空，系统自动关
                }
            } message: {
                Text("There was an issue fetching some of your data. "
                     + "Some health tracking requires an Apple Watch.")
            }
            
            if showTerms {
                Color.white
                
                TermsView(showTerms: $showTerms)
            }
            
        }
        .onChange(of: showTerms) { _ in
            if !showTerms && username != nil {
                viewModel.setupLeaderboardData()
            }
            
        }
    }
}

#Preview {
    LeaderboardView(showTerms: .constant(false))
}
