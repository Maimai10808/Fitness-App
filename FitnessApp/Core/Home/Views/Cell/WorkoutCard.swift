//
//  WorkoutCard.swift
//  FitnessApp
//
//  Created by mac on 4/3/25.
//

import SwiftUI

struct WorkoutCard: View {
    @State var workout: Workout
    
    var body: some View {
        HStack {
            Image(systemName: workout.image)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundStyle(workout.tintColor)
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
            
            VStack(spacing: 16) {
                HStack {
                    Text(workout.title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .font(.title3)
                        .bold()
                    
                    Spacer()
                    
                    Text(workout.duration)
                }
                
                HStack {
                    Text(workout.date.formatWorkoutDate())
                    
                    Spacer()
                    
                    Text("\(workout.calories) kcal")
                }
            }
        }
        .padding()
    }
}

#Preview {
    WorkoutCard(workout: Workout(title: "Running", image: "figure.run", duration: "52 mins" , date: Date(), calories: "512 kcal", tintColor: .green))
}
