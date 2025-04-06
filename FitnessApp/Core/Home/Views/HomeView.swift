//
//  HomeView.swift
//  FitnessApp
//
//  Created by mac on 4/3/25.
//

import SwiftUI

struct HomeView: View {
    
    
    @StateObject var viewModel = HomeViewModel()
    
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
                        ProgressCircleView(progress: $viewModel.calories, goal: 600, color: .red)
                        
                        ProgressCircleView(progress: $viewModel.exercise, goal: 60, color: .green)
                            .padding(.all, 20)
                        
                        ProgressCircleView(progress: $viewModel.stand, goal: 12, color: .blue)
                            .padding(.all, 40)
                        
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
                        print("show more")
                    } label: {
                        Text("Show more")
                            .padding(.all, 10)
                            .foregroundStyle(.white)
                            .background(.blue)
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal)
                
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                    ForEach(viewModel.mockActivites, id: \.title) {
                        activity in
                        ActivityCard(activity: activity)
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Recent Workouts")
                        .font(.title2)
                    
                    Spacer()
                    
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Text("Show more")
                            .padding(.all, 10)
                            .foregroundStyle(.white)
                            .background(.blue)
                            .cornerRadius(20)
                    }
                    
                }
                .padding(.horizontal)
                .padding(.top)
                
                LazyVStack {
                    ForEach(viewModel.mockWorkouts, id: \.id) { workout in WorkoutCard(workout: workout)
                    }
                }
                .padding(.bottom)
         }
      }
    }
  }
}



#Preview {
    HomeView()
}



