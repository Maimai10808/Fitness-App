//
//  PaywallView.swift
//  FitnessApp
//
//  Created by mac on 4/10/25.
//

import SwiftUI
import RevenueCat


class PaywallViewModel: ObservableObject {
    @Published var currentOffering: Offering?
    @Published var customerInfo: CustomerInfo?

    init() {
        fetchOfferings()
        fetchCustomerInfo()
    }

    // 使用 Completion Blocks 获取 Offerings
    func fetchOfferings() {
        Purchases.shared.getOfferings { (offerings, error) in
            if let offering = offerings?.current {
                DispatchQueue.main.async {
                    self.currentOffering = offering
                }
            } else if let error = error {
                // Handle error if fetching offerings fails
                print("Error fetching offerings: \(error.localizedDescription)")
            }
        }
    }

    // 使用 Completion Blocks 获取 CustomerInfo
    func fetchCustomerInfo() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if let customerInfo = customerInfo {
                DispatchQueue.main.async {
                    self.customerInfo = customerInfo
                }
            } else if let error = error {
                // Handle error if fetching customer info fails
                print("Error fetching customer info: \(error.localizedDescription)")
            }
        }
    }
}


struct PaywallView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = PaywallViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Premium Membership")
                .font(.largeTitle)
                .bold()
            
            Text("Get fit, get active, today")
            
            
            Spacer()
            
            
            // Features
            
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "figure.run")
                    
                    Text("Exercise boosts energy levels and promotes vitality")
                        .lineLimit(1)
                        .font(.system(size: 14))
                }
                
                HStack {
                    Image(systemName: "figure.run")
                    
                    Text("Exercise boosts energy levels and promotes vitality")
                        .lineLimit(1)
                        .font(.system(size: 14))
                }
                
                HStack {
                    Image(systemName: "figure.run")
                    
                    Text("Exercise boosts energy levels and promotes vitality")
                        .lineLimit(1)
                        .font(.system(size: 14))
                }
            }
            .padding(.vertical)
            
            Spacer()
            
            Button {
                
            } label: {
                Text("test")
            }
            
            if let offering = viewModel.currentOffering {
                ForEach(offering.availablePackages) { package in
                    Button {
                        Purchases.shared.purchase(package: package) { (transaction, customerInfo, error, userCancelled) in
                            if customerInfo?.entitlements["premium"]?.isActive == true {
                                // Unlock that "pro" content
                                
                                dismiss()
                            }
                            
                            
                            
                        }
                    } label: {
                        Text(package.storeProduct.localizedTitle)
                        
                        Text(package.storeProduct.localizedPriceString)
                    }
                    
                }
            }
            

        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

#Preview {
    PaywallView()
}
