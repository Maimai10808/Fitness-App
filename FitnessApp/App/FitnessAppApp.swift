//
//  FitnessAppApp.swift
//  FitnessApp
//
//  Created by mac on 4/3/25.
//

import SwiftUI
import RevenueCat

@main
struct FitnessAppApp: App {
    
    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_SjJfmfZzUoPeDPumcPMxLFGhyVx")
    }
    var body: some Scene {
        WindowGroup {
            FitnessTabView()
                .onAppear {
                    Purchases.shared.getOfferings { (offerings, error) in
                        if let packages = offerings?.current?.availablePackages {
                            print(packages.first?.offeringIdentifier)
                        }
                        
                    }
                }
        }
    }
}
