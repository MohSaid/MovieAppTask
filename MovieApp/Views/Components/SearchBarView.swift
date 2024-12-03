//
//  SearchBarView.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 01/12/2024.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String

    var body: some View {
        TextField("Search TMDB", text: $searchText)
            .accessibilityIdentifier("searchBar")
            .padding(10)
            .background(Color.white.opacity(0.5))
            .cornerRadius(8)
            .padding(.horizontal)
    }
}
