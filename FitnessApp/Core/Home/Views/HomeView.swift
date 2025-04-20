//
//  HomeView.swift
//  FitnessApp
//
//  Created by mac on 4/3/25.
//

import SwiftUI

struct HomeView: View {
    
    
    @StateObject var viewModel = HomeViewModel()
    
    @State var isPremium = false
    @State var showPaywall = false
    @State var activitiesAmount = 4
    @State var showAllActivities = false
    
    
    
    var body: some View {
    NavigationStack {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("Welcome")
                    .font(.largeTitle)
                    .padding()
                
                HStack {
                    
                    Spacer()
                    
                    VStack  {
                        VStack(alignment: .leading,spacing: 8) {
                            Text("Steps")
                                .font(.callout)
                                .bold()
                                .foregroundStyle(.purple)
                            
                            Text("\(viewModel.steps)")
                                .bold()
                        }
                        .padding(.bottom)
                        
                        VStack(alignment: .leading,spacing: 8) {
                            Text("calories")
                                .font(.callout)
                                .bold()
                                .foregroundStyle(.red)
                            
                            Text("\(viewModel.calories)")
                                .bold()
                        }
                        .padding(.bottom)
                        
                        VStack(alignment: .leading,spacing: 8) {
                            Text("Active")
                                .font(.callout)
                                .bold()
                                .foregroundStyle(.green)
                            
                            Text("\(viewModel.exercise)")
                                .bold()
                        }
                        .padding(.bottom)
                        
                        VStack(alignment: .leading,spacing: 8) {
                            Text("Stand")
                                .font(.callout)
                                .bold()
                                .foregroundStyle(.blue)
                            
                            Text("\(viewModel.stand)")
                                .bold()
                        }
                        .padding(.bottom)
                        
                    }
                    
                    Spacer()
                    
                    ZStack {
                        ProgressCircleView(progress: $viewModel.steps, goal: 10000, color: .purple)
                        
                        ProgressCircleView(progress: $viewModel.calories, goal: 600, color: .red)
                            .padding(.all, 20)
                        
                        ProgressCircleView(progress: $viewModel.exercise, goal: 60, color: .green)
                            .padding(.all, 40)
                        
                        ProgressCircleView(progress: $viewModel.stand, goal: 12, color: .blue)
                            .padding(.all, 60)
                        
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                }
                .padding()
                
                HStack {
                    Text("Fitness Activity")
                        .font(.title2)
                    
                    Spacer()
                    
                    Button {
                        
                        if isPremium {
                            
                            showAllActivities.toggle()
                            
                            if showAllActivities {
                                AlertPresenter.presentAlert(title: "Remind", message: " Have got access")
                            } else {
                                AlertPresenter.presentAlert(title: "Remind", message: " Have limited access")
                            }
                            
                        } else {
                            showPaywall = true
                        }
                        
                        
                        
                    } label: {
                        Text("Show more")
                            .padding(.all, 10)
                            .foregroundStyle(.white)
                            .background(.blue)
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal)
                
                if !viewModel.activities.isEmpty {
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                        ForEach(viewModel.activities.prefix(showAllActivities == true ? 8 : 4 ), id: \.title) {
                            activity in
                            ActivityCard(activity: activity)
                        }
                    }
                    .padding(.horizontal)
                }
                
                
                HStack {
                    Text("Recent Workouts")
                        .font(.title2)
                    
                    Spacer()
                    
                    if isPremium {
                        NavigationLink {
                            MonthWorkoutsView()
                        } label: {
                            Text("Show more")
                                .padding(.all, 10)
                                .foregroundStyle(.white)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                    } else {
                        Button {
                            showPaywall = true
                        } label: {
                            Text("Show more")
                                .padding(.all, 10)
                                .foregroundStyle(.white)
                                .foregroundStyle(.white)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                    }
                    
                    
                }
                .padding(.horizontal)
                .padding(.top)
                
                LazyVStack {
                    ForEach(viewModel.workouts, id: \.calories) { workout in WorkoutCard(workout: workout)
                    }
                }
                .padding(.bottom)
         }
      }
    }
    .alert("Oops",
           isPresented: $viewModel.presentError) {
        // ✅ 用 Button 才能点
        Button("OK", role: .cancel) {
            viewModel.presentError = false   // 也可以留空，系统自动关
        }
    } message: {
        Text("There was an issue fetching some of your data. "
             + "Some health tracking requires an Apple Watch.")
    }
        
  }
}



#Preview {
    HomeView()
}



