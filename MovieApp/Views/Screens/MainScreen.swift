//
//  GenreList.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 28/11/2024.
//

import SwiftUI

struct MainScreen: View {
    @StateObject private var genresViewModel = GenreViewModel()
    @StateObject private var moviesViewModel = MovieViewModel()
    @State private var selectedGenre: Genre?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Search Bar
                SearchBar(searchText: $moviesViewModel.searchText).accessibilityIdentifier("SearchBar")
                    .onChange(of: moviesViewModel.searchText) { _ in
                        moviesViewModel.filterMovies(for: selectedGenre?.id)
                    }
                
                Text("Watch New Movies")
                    .font(.title)
                    .bold()
                    .foregroundColor(.yellow)
                    .padding(.horizontal)
                
                // Genre List
                GenreListView(
                    genres: genresViewModel.genres,
                    selectedGenre: $selectedGenre
                ).accessibilityIdentifier("genreList")
                .onChange(of: selectedGenre) { genre in
                    moviesViewModel.filterMovies(for: genre?.id)
                }
                
                Spacer()
                
                // Movies Grid
                MoviesGridView(
                    movies: moviesViewModel.movies,
                    isLoading: moviesViewModel.isLoading,
                    errorMessage: moviesViewModel.errorMessage,
                    loadMoreAction: {
                        moviesViewModel.fetchMovies(for: selectedGenre?.id) 
                    }
                ).accessibilityIdentifier("MoviesGridView")

            }
            .navigationBarHidden(true)
            .padding(.top)
            .onAppear {
                genresViewModel.fetchGenres()
                moviesViewModel.fetchMovies(for: nil, reset: true)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .statusBar(hidden: true)
    }
}


#Preview {
    MainScreen()
}
