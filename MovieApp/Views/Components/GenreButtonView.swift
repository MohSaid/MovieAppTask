//
//  GenreButtonView.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 01/12/2024.
//


import SwiftUI

struct GenreButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .foregroundColor(isSelected ? .black : .white)
                .background(isSelected ? Color.yellow : Color.clear)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected ? Color.clear : Color.yellow, lineWidth: 2)  // Border color
                )
        }
    }
}



#Preview {
    GenreButton(title: "Action", isSelected: false) {
        
        print("Action")
    }
}
