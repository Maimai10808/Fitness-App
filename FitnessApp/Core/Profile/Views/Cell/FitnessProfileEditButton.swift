//
//  FitnessProfileEditButton.swift
//  FitnessApp
//
//  Created by mac on 4/19/25.
//

import SwiftUI

struct FitnessProfileEditButton: View {
    var title: String
    var backgroundColor: Color
    var action: (() -> Void)
    
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .padding()
                .frame(maxWidth: 200)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(backgroundColor)
                )
        }
    }
}

#Preview {
    FitnessProfileEditButton(title: "Cancle", backgroundColor: .red) {}
}
