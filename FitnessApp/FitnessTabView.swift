//
//  FitnessTabView.swift
//  FitnessApp
//
//  Created by mac on 4/3/25.
//

import SwiftUI
import RevenueCat

struct FitnessTabView: View {
    @State var selectedTab = "Home"
    
    @AppStorage("username") var username: String?
    
    @State var isPremium = false
    
    @State var showTerms = true
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.stackedLayoutAppearance.selected.iconColor = .blue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag("Home")
                .tabItem {
                    Image(systemName: "house")
                    
                    Text("Home")
                }
            
            ChartsView()
                .tag("Historic")
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    
                    Text("Charts")
                }
            
            LeaderboardView(showTerms: $showTerms)
                .tag("Leaderboard")
                .tabItem {
                    Image(systemName: "list.bullet")
                    
                    Text("Leaderboard")
                }
            
            ProfileView()
                .tag("Profile")
                .tabItem {
                    Image(systemName: "person")
                    
                    Text("Profile")
                }
        }
        .onAppear {
            print(username)
            showTerms = username == nil
            Purchases.shared.getCustomerInfo {
                CustomerInfo, error in
                isPremium = CustomerInfo?.entitlements["premium"]?.isActive == true
            }
        }
    }
}

#Preview {
    FitnessTabView()
}
