//
//  HKWorkoutActivityType+Ext.swift
//  FitnessApp
//
//  Created by mac on 4/8/25.
//

import Foundation
import HealthKit
import UIKit
import SwiftUI

extension HKWorkoutActivityType {
    
    /// 根据运动类型返回友好的名称
    var name: String {
        switch self {
        case .americanFootball:             return "American Football"
        case .archery:                      return "Archery"
        case .australianFootball:           return "Australian Football"
        case .badminton:                    return "Badminton"
        case .baseball:                     return "Baseball"
        case .basketball:                   return "Basketball"
        case .bowling:                      return "Bowling"
        case .boxing:                       return "Boxing"
        case .climbing:                     return "Climbing"
        case .crossTraining:                return "Cross Training"
        case .curling:                      return "Curling"
        case .cycling:                      return "Cycling"
        case .dance:                        return "Dance"
        case .danceInspiredTraining:        return "Dance Inspired Training"
        case .elliptical:                   return "Elliptical"
        case .equestrianSports:             return "Equestrian Sports"
        case .fencing:                      return "Fencing"
        case .fishing:                      return "Fishing"
        case .functionalStrengthTraining:   return "Functional Strength Training"
        case .golf:                         return "Golf"
        case .gymnastics:                   return "Gymnastics"
        case .handball:                     return "Handball"
        case .hiking:                       return "Hiking"
        case .hockey:                       return "Hockey"
        case .hunting:                      return "Hunting"
        case .lacrosse:                     return "Lacrosse"
        case .martialArts:                  return "Martial Arts"
        case .mindAndBody:                  return "Mind and Body"
        case .mixedMetabolicCardioTraining: return "Mixed Metabolic Cardio Training"
        case .paddleSports:                 return "Paddle Sports"
        case .play:                         return "Play"
        case .preparationAndRecovery:       return "Preparation and Recovery"
        case .racquetball:                  return "Racquetball"
        case .rowing:                       return "Rowing"
        case .rugby:                        return "Rugby"
        case .running:                      return "Running"
        case .sailing:                      return "Sailing"
        case .skatingSports:                return "Skating Sports"
        case .snowSports:                   return "Snow Sports"
        case .soccer:                       return "Soccer"
        case .softball:                     return "Softball"
        case .squash:                       return "Squash"
        case .stairClimbing:                return "Stair Climbing"
        case .surfingSports:                return "Surfing Sports"
        case .swimming:                     return "Swimming"
        case .tableTennis:                  return "Table Tennis"
        case .tennis:                       return "Tennis"
        case .trackAndField:                return "Track and Field"
        case .traditionalStrengthTraining:  return "Traditional Strength Training"
        case .volleyball:                   return "Volleyball"
        case .walking:                      return "Walking"
        case .waterFitness:                 return "Water Fitness"
        case .waterPolo:                    return "Water Polo"
        case .waterSports:                  return "Water Sports"
        case .wrestling:                    return "Wrestling"
        case .yoga:                         return "Yoga"
            
        // iOS 10
        case .barre:                        return "Barre"
        case .coreTraining:                 return "Core Training"
        case .crossCountrySkiing:           return "Cross Country Skiing"
        case .downhillSkiing:               return "Downhill Skiing"
        case .flexibility:                  return "Flexibility"
        case .highIntensityIntervalTraining:return "High Intensity Interval Training"
        case .jumpRope:                     return "Jump Rope"
        case .kickboxing:                   return "Kickboxing"
        case .pilates:                      return "Pilates"
        case .snowboarding:                 return "Snowboarding"
        case .stairs:                       return "Stairs"
        case .stepTraining:                 return "Step Training"
        case .wheelchairWalkPace:           return "Wheelchair Walk Pace"
        case .wheelchairRunPace:            return "Wheelchair Run Pace"
            
        // iOS 11
        case .taiChi:                       return "Tai Chi"
        case .mixedCardio:                  return "Mixed Cardio"
        case .handCycling:                  return "Hand Cycling"
            
        // iOS 13
        case .discSports:                   return "Disc Sports"
        case .fitnessGaming:                return "Fitness Gaming"
            
        // Catch-all
        default:                            return "Other"
        }
    }
    
    /// 根据运动类型返回相应的 SF Symbols 名称
    var image: String {
        switch self {
        // 球类运动
        case .americanFootball:
            return "sportscourt"                      // 无专用符号时使用通用球场图标
        case .archery:
            return "scope"                            // 可以传达瞄准的概念
        case .australianFootball:
            return "sportscourt"                      // 同上
        case .badminton:
            return "sportscourt"
        case .baseball:
            return "sportscourt"
        case .basketball:
            return "sportscourt"
        case .bowling:
            return "sportscourt"
        case .boxing:
            return "figure.boxing"                    // iOS 部分版本支持
        case .climbing:
            return "figure.climbing"
        case .crossTraining:
            return "figure.training.cross"
        case .curling:
            return "sportscourt"
        case .cycling:
            return "bicycle"
        case .dance:
            return "figure.dance"
        case .danceInspiredTraining:
            return "figure.dance"
        case .elliptical:
            return "figure.elliptical"                // 若系统中无此符号，可考虑自定义替代
        case .equestrianSports:
            return "sportscourt"                      // 无专用符号时使用通用图标
        case .fencing:
            return "figure.fencing"                    // iOS 部分版本支持
        case .fishing:
            return "fish"
        case .functionalStrengthTraining:
            return "figure.strengthtraining.functional"
        case .golf:
            return "sportscourt"                      // 或使用自定义图标
        case .gymnastics:
            return "figure.gymnastics"
        case .handball:
            return "figure.handball"
        case .hiking:
            return "figure.hiking"
        case .hockey:
            return "sportscourt"                      // 或“figure.hockey”若符号可用
        case .hunting:
            return "scope"                            // 以“scope”表达瞄准或猎人视角
        case .lacrosse:
            return "sportscourt"
        case .martialArts:
            return "figure.martialarts"
        case .mindAndBody:
            return "brain.head.profile"
        case .mixedMetabolicCardioTraining:
            return "figure.run"
        case .paddleSports:
            return "figure.paddle"
        case .play:
            return "gamecontroller"
        case .preparationAndRecovery:
            return "heart.circle"
        case .racquetball:
            return "sportscourt"
        case .rowing:
            return "figure.rowing"
        case .rugby:
            return "sportscourt"
        case .running:
            return "figure.run"
        case .sailing:
            return "sailboat"
        case .skatingSports:
            return "figure.skating"
        case .snowSports:
            return "snowflake"
        case .soccer:
            return "sportscourt"
        case .softball:
            return "sportscourt"
        case .squash:
            return "sportscourt"
        case .stairClimbing:
            return "figure.stair.stepper"
        case .surfingSports:
            return "wave.3.forward"
        case .swimming:
            return "figure.swimming"
        case .tableTennis:
            return "sportscourt"
        case .tennis:
            return "sportscourt"
        case .trackAndField:
            return "figure.run"
        case .traditionalStrengthTraining:
            return "figure.strengthtraining.traditional"
        case .volleyball:
            return "sportscourt"
        case .walking:
            return "figure.walk"
        case .waterFitness:
            return "drop.fill"                         // 若有更合适的图标可替换
        case .waterPolo:
            return "sportscourt"
        case .waterSports:
            return "sportscourt"
        case .wrestling:
            return "figure.wrestling"                   // iOS 部分版本支持
        case .yoga:
            return "figure.yoga"                        // iOS 部分版本支持
            
        // iOS 10
        case .barre:
            return "figure.barre"                       // 若符号不可用可用“figure.dance”替代
        case .coreTraining:
            return "figure.core.training"
        case .crossCountrySkiing:
            return "figure.ski.crosscountry"
        case .downhillSkiing:
            return "figure.ski.downhill"
        case .flexibility:
            return "figure.flexibility"
        case .highIntensityIntervalTraining:
            return "figure.highintensity.training"      // 建议检查系统符号库是否支持该名称
        case .jumpRope:
            return "figure.jumprope"                      // 同上
        case .kickboxing:
            return "figure.kickboxing"                    // 同上
        case .pilates:
            return "figure.pilates"
        case .snowboarding:
            return "figure.snowboarding"
        case .stairs:
            return "figure.stairs"
        case .stepTraining:
            return "figure.steptraining"
        case .wheelchairWalkPace:
            return "figure.wheelchair.walk"
        case .wheelchairRunPace:
            return "figure.wheelchair.run"
            
        // iOS 11
        case .taiChi:
            return "figure.taichi"
        case .mixedCardio:
            return "figure.mixcardio"
        case .handCycling:
            return "bicycle"                           // 可考虑“figure.handcycling”，若系统提供该符号
            
        // iOS 13
        case .discSports:
            return "disc"
        case .fitnessGaming:
            return "gamecontroller"
            
        // Catch-all
        default:
            return "questionmark"
        }
    }
    
    /// 根据运动类型返回相应的颜色
    var color: Color {
        switch self {
        // 球类运动
        case .americanFootball,
             .australianFootball,
             .baseball,
             .basketball,
             .handball,
             .lacrosse,
             .rugby,
             .soccer,
             .softball,
             .volleyball,
             .squash,
             .tableTennis,
             .tennis:
            return Color(uiColor: .systemRed)
            
        // 户外及耐力运动
        case .cycling,
             .running,
             .walking,
             .trackAndField,
             .rowing,
             .swimming,
             .hiking,
             .handCycling:
            return Color(uiColor: .systemBlue)
            
        // 健身及力量训练
        case .crossTraining,
             .functionalStrengthTraining,
             .traditionalStrengthTraining,
             .mixedMetabolicCardioTraining,
             .coreTraining:
            return Color(uiColor: .systemOrange)
            
        // 舞蹈与柔韧类运动
        case .dance,
             .danceInspiredTraining,
             .gymnastics,
             .pilates,
             .taiChi,
             .mindAndBody,
             .barre:
            return Color(uiColor: .systemPurple)
            
        // 冬季运动
        case .crossCountrySkiing,
             .downhillSkiing,
             .snowSports,
             .snowboarding:
            return Color(uiColor: .systemTeal)
            
        // 技巧及非传统体育
        case .archery,
             .fishing,
             .hunting:
            return Color(uiColor: .systemGreen)
            
        // 休闲与恢复类
        case .preparationAndRecovery,
             .flexibility,
             .stepTraining,
             .stairs:
            return Color(uiColor: .systemGray)
            
        // 其他类别：未特别归类的使用默认颜色
        default:
            return Color(uiColor: .systemIndigo)
        }
    }
}
