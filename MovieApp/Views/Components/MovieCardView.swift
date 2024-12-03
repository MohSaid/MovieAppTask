//
//  MovieCardView.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 01/12/2024.
//

import SwiftUI

struct MovieCard: View {
    let movie: Movie
    @StateObject private var imageLoader: ImageLoader

    init(movie: Movie) {
        self.movie = movie
        _imageLoader = StateObject(
            wrappedValue: ImageLoaderCache.shared.loaderFor(
                path: movie.posterURL?.absoluteString,
                size: .medium
            )
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Movie Poster
            Group {
                if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250) // Fixed height for consistency
                        .clipped()
                } else {
                    Image("placeholder")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                }
            }

            Text(movie.title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(2) // Allow wrapping to two lines
                .minimumScaleFactor(0.8) // Scale down text if it overflows
                .frame(height: 40)
                .padding(.horizontal ,8)// Set a fixed height for consistent card layout

            Text(movie.releaseYear)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding([.leading , .bottom] ,8)
        }
        .background(Color.gray.opacity(0.2))

    }
}




#Preview {
    MovieCard(movie: Movie(id: 10, title: "Movie Title", genreIDs: [], releaseDate: "2001-01-01", posterPath: ""))
}
