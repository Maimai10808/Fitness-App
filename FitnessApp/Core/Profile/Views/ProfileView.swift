//
//  ProfileView.swift
//  FitnessApp
//
//  Created by mac on 4/19/25.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(viewModel.profileImage)
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
                            viewModel.presentEditImage()
                        }
                    }
                
                VStack(alignment: .leading) {
                    Text("Good morning,")
                        .font(.largeTitle)
                        .foregroundStyle(.gray)
                    
                    Text(viewModel.profileName)
                        .font(.title)
                }
            }
            
            if viewModel.isEditingName {
                TextField("Name...", text: $viewModel.currentName)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
                
                HStack {
                    FitnessProfileEditButton(title: "Cancel", backgroundColor: .red) {
                        withAnimation(.smooth) {
                            viewModel.dismissEdit()
                        }
                    }
                    .foregroundStyle(.red)
                    
                    FitnessProfileEditButton(title: "Done", backgroundColor: .primary) {
                        if !viewModel.currentName.isEmpty {
                            withAnimation(.smooth) {
                                viewModel.setNewName()
                            }
                        }
                    }
                    .foregroundStyle(Color(uiColor: .systemBackground))
                }
                .padding(.bottom)
            }
            
            if viewModel.isEditingImage {
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.images, id: \.self) { image in
                            Button {
                                withAnimation(.smooth) {
                                    viewModel.selectedImage = image
                                }
                            } label: {
                                VStack {
                                    Image(image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                    
                                    if viewModel.selectedImage == image {
                                        Circle()
                                            .frame(width: 16, height: 16)
                                            .foregroundStyle(.primary)
                                    }
                                }
                                
                                    .padding()
                            }
                            .shadow(radius: viewModel.selectedImage == image ? 5 : 0)
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
                            viewModel.dismissEdit()
                        }
                    }
                    .foregroundStyle(.red)
                    
                    FitnessProfileEditButton(title: "Done", backgroundColor: .primary) {
                        withAnimation(.smooth) {
                            viewModel.selectImage()
                        }
                    }
                    
                }
                
            }
            
            
            VStack {
                
                FitnessProfileItemButton(title: "Edit name",image: "square.and.pencil") {
                    withAnimation(.smooth) {
                        viewModel.presentEditName()
                    }
                }
                FitnessProfileItemButton(title: "Edit image",image: "square.and.pencil") {
                    withAnimation(.smooth) {
                        viewModel.presentEditImage()
                    }
                }
                
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.25))
            )
            .padding(.top)
            
            VStack {
                
                FitnessProfileItemButton(title: "Contact US", image: "envelope") {
                    viewModel.presentEmailApp()
                }
                
                Link(destination: URL(string: "https://github.com/Maimai10808/Fitness-App")!) {
                    HStack {
                        Image(systemName: "doc")
                        
                        Text("Privacy Policy")
                    }
                    .foregroundStyle(.primary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Link(destination: URL(string: "https://github.com/Maimai10808/Fitness-App")!) {
                    HStack {
                        Image(systemName: "doc")
                        
                        Text("Terms of Service")
                    }
                    .foregroundStyle(.primary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
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
            viewModel.selectedImage = viewModel.profileImage
        }
    }
}

#Preview {
    ProfileView()
}
