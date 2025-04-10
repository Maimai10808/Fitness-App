//
//  Activity.swift
//  FitnessApp
//
//  Created by mac on 4/3/25.
//

import Foundation
import SwiftUI

struct Activity {
    let id: Int?
    let title: String
    let subtitle: String
    let image: String
    let tintColor: Color
    let amount: String
}

struct Workout {
    let id: Int?
    let title: String
    let image: String
    let duration: String
    let date: String
    let calories: String
    let tintColor: Color
}
