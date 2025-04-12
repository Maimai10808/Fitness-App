//
//  LeaderboardView.swift
//  FitnessApp
//
//  Created by mac on 4/10/25.
//

import SwiftUI
import Foundation

struct LeaderboardView: View {
    
    @StateObject var viewModel = LeaderboardViewModel()
        
    @Binding var showTerms: Bool
    
    var body: some View {
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
            
            LazyVStack(spacing: 16) {
                ForEach(viewModel.mockData) { person in
                    HStack {
                        Text("1.")
                        
                        Text(person.username)
                        
                        Spacer()
                        
                        Text("\(person.count)")
                    }
                    .padding(.horizontal)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .fullScreenCover(isPresented: $showTerms) {
            TermsView()
        }
        .task {
            do {
                try await DatabaseManager.shared.postStepCountUpdateFor(username: "jason", count: 1240)
            } catch {
                print(error.localizedDescription)
            }
        }
        .onAppear {
            print( Date().MondayDateFormat() )
        }
        
    }
}

#Preview {
    LeaderboardView(showTerms: .constant(false))
}
