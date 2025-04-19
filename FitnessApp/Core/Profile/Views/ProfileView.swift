//
//  ProfileView.swift
//  FitnessApp
//
//  Created by mac on 4/19/25.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("profileName")  var profileName:  String?
    @AppStorage("profileImage") var profileImage: String?
    
    @State  private var isEditingName = false
    @State private var currentName: String = ""
    @State  private var isEditingImage = false
    @State private var  selectedImage: String?
    var images = [ "avatar 1", "avatar 2", "avatar 3", "avatar 4", "avatar 5", "avatar 6", "avatar 7", "avatar 8", "avatar 9", "avatar 10"
    ]
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(profileImage ?? "avatar 1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.all, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.gray.opacity(0.4))
                    )
                    .onTapGesture {
                        withAnimation(.smooth) {
                            isEditingName = false
                            isEditingImage = true
                        }
                    }
                
                VStack(alignment: .leading) {
                    Text("Good morning,")
                        .font(.largeTitle)
                        .foregroundStyle(.gray)
                    
                    Text(profileName ?? "Name")
                        .font(.title)
                }
            }
            
            if isEditingName {
                TextField("Name...", text: $currentName)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
                
                HStack {
                    FitnessProfileEditButton(title: "Cancel", backgroundColor: .red) {
                        withAnimation(.smooth) {
                            isEditingName = false
                        }
                    }
                    .foregroundStyle(.red)
                    
                    FitnessProfileEditButton(title: "Done", backgroundColor: .primary) {
                        if !currentName.isEmpty {
                            withAnimation(.smooth) {
                                profileName = currentName
                                isEditingName = false
                            }
                        }
                    }
                    .foregroundStyle(Color(uiColor: .systemBackground))
                }
                .padding(.bottom)
            }
            
            if isEditingImage {
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(images, id: \.self) { image in
                            Button {
                                withAnimation(.smooth) {
                                    selectedImage = image
                                }
                            } label: {
                                VStack {
                                    Image(image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                    
                                    if selectedImage == image {
                                        Circle()
                                            .frame(width: 16, height: 16)
                                            .foregroundStyle(.primary)
                                    }
                                }
                                
                                    .padding()
                            }
                            .shadow(radius: selectedImage == image ? 5 : 0)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.25))
                )
                
                HStack {
                    FitnessProfileEditButton(title: "Cancel", backgroundColor: .red) {
                        withAnimation(.smooth) {
                            isEditingImage = false
                        }
                    }
                    .foregroundStyle(.red)
                    
                    FitnessProfileEditButton(title: "Done", backgroundColor: .primary) {
                        withAnimation(.smooth) {
                            profileImage = selectedImage
                            isEditingImage = false
                        }
                    }
                    
                }
                
            }
            
            
            VStack {
                
                FitnessProfileItemButton(title: "Edit name",image: "square.and.pencil") {
                    withAnimation(.smooth) {
                        isEditingName = true
                        isEditingImage = false
                    }
                }
                FitnessProfileItemButton(title: "Edit image",image: "square.and.pencil") {
                    withAnimation(.smooth) {
                        isEditingName = false
                        isEditingImage = true
                    }
                }
                
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.25))
            )
            
            VStack {
                
                FitnessProfileItemButton(title: "Contact US",image: "envelope") {
                    print("Contact US")
                }
                FitnessProfileItemButton(title: "Privacy Policy",image: "doc") {
                    print("Privacy Policy")
                }
                FitnessProfileItemButton(title: "Terms of Service",image: "doc") {
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
        .onAppear {
            selectedImage = profileImage
        }
    }
}

#Preview {
    ProfileView()
}
