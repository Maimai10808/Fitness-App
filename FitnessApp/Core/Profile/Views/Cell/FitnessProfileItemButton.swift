//
//  FitnessProfileButton.swift
//  FitnessApp
//
//  Created by mac on 4/19/25.
//

import SwiftUI

struct FitnessProfileItemButton: View {
    @State var title: String
    @State var image : String
    var action: (() -> Void)
    
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: image)
                
                Text(title)
            }
            .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    FitnessProfileItemButton(title: "Edit image",image: "square.and.pencil") {}
}
