//
//  FitnessAppApp.swift
//  FitnessApp
//
//  Created by mac on 4/3/25.
//

import SwiftUI
import RevenueCat
import FirebaseCore



class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}



@main
struct FitnessAppApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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
