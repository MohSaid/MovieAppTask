//
//  MoviesGridView.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 01/12/2024.
//

import SwiftUI


struct MoviesGridView: View {
    let movies: [Movie]
    let isLoading: Bool
    let errorMessage: String?
    let loadMoreAction: () -> Void

    @State private var selectedMovieID: Int?

    var body: some View {
        Group {
            if isLoading && movies.isEmpty {
                loadingView
            } else if let errorMessage = errorMessage {
                errorView(message: errorMessage)
            } else {
                moviesGridView
            }
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .padding()
    }
    
    private func errorView(message: String) -> some View {
        Text(message)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    private var moviesGridView: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                ForEach(movies, id: \.id) { movie in
                    movieCard(movie: movie)
                }
            }
            .padding()
        }
    }
    
    private func movieCard(movie: Movie) -> some View {
        NavigationLink(
            destination: MovieDetailView(movieID: Binding(
                get: { selectedMovieID ?? movie.id },
                set: { selectedMovieID = $0 }
            )),
            tag: movie.id,
            selection: $selectedMovieID
        ) {
            MovieCard(movie: movie)
                .onAppear {
                    loadMoreContentIfNeeded(for: movie)
                }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func loadMoreContentIfNeeded(for movie: Movie) {
        if movies.last == movie {
            loadMoreAction()
        }
    }
}
