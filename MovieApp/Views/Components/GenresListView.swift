//
//  GenresListView.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 01/12/2024.
//

import SwiftUI

struct GenreListView: View {
    let genres: [Genre]
    @Binding var selectedGenre: Genre?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                GenreButton(
                    title: "All",
                    isSelected: selectedGenre == nil,
                    action: { selectedGenre = nil }
                )

                ForEach(genres, id: \.id) { genre in
                    GenreButton(
                        title: genre.name,
                        isSelected: selectedGenre?.id == genre.id,
                        action: { selectedGenre = genre }
                    )
                }
            }
            .padding(.horizontal)
            .accessibilityIdentifier("genreList")
        }
    }
}
