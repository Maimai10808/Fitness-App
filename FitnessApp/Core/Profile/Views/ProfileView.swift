//
//  ProfileView.swift
//  FitnessApp
//
//  Created by mac on 4/19/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image("avatar 1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.all, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.gray.opacity(0.4))
                    )
                
                VStack(alignment: .leading) {
                    Text("Good morning,")
                        .font(.largeTitle)
                        .foregroundStyle(.gray)
                    
                    Text("Name")
                        .font(.title)
                }
            }
            
            VStack {
                
                FitnessProfileButton(title: "Edit name",image: "square.and.pencil") {
                    print("Edit name")
                }
                FitnessProfileButton(title: "Edit image",image: "square.and.pencil") {
                    print("Edit image")
                }
                
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.25))
            )
            
            VStack {
                
                FitnessProfileButton(title: "Contact US",image: "envelope") {
                    print("Contact US")
                }
                FitnessProfileButton(title: "Privacy Policy",image: "doc") {
                    print("Privacy Policy")
                }
                FitnessProfileButton(title: "Terms of Service",image: "doc") {
                    print("Terms of Service")
                }
                
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            )
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

#Preview {
    ProfileView()
}
