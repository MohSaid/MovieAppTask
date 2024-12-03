//
//  MovieDetailsScreen.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 02/12/2024.
//

import SwiftUI
import Combine

struct MovieDetailView: View {
    @StateObject private var viewModel = MovieDetailViewModel()
    @State private var posterImage: UIImage?
    @Binding var movieID: Int
    
    private var cancellables = Set<AnyCancellable>()
    
    // Access the presentation mode for navigation control
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                moviePosterView
                    .frame(height: UIScreen.main.bounds.height * 1/3)
                    .clipped()
                    .edgesIgnoringSafeArea(.top)
                
                // Title and Genres directly under the poster
                if let movie = viewModel.detailedMovie {
                    MovieTitleAndGenresView(movie: movie, posterImage: posterImage)
                        .padding(.top, -80)
                }
                
                Group {
                    if viewModel.isLoading {
                        loadingView
                    } else if let errorMessage = viewModel.errorMessage {
                        errorView(message: errorMessage)
                    } else if let movie = viewModel.detailedMovie {
                        MovieDetailsView(movie: movie)
                    } else {
                        Text("No movie details available.")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black)
                    }
                }

            }
            .background(Color.black)
            .navigationBarItems(leading: customBackButton) // Add the custom back button
            .onAppear {
                onAppearAction()
            }
            .onChange(of: movieID) { newMovieID in
                onChangeAction(newMovieID: newMovieID)
            }
            .onChange(of: viewModel.detailedMovie) { _ in
                if let posterPath = viewModel.detailedMovie?.posterPath {
                    fetchImage(from: posterPath)
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    internal init(movieID: Binding<Int>) {
        self._movieID = movieID
    }
    
    // Custom Back Button
    private var customBackButton: some View {
        Button(action: {
            // Dismiss the current view (navigate back)
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.white)
                .imageScale(.large)
        }
    }
    
    // Poster Image View
    private var moviePosterView: some View {
        Group {
            if let image = posterImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image("placeholder")
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(height: UIScreen.main.bounds.height * 1 / 3)
        .background(Color.black) // Maintain consistent background color
        .clipped()
    }
    
    struct MovieTitleAndGenresView: View {
        var movie: DetailedMovie
        var posterImage: UIImage?
        
        var body: some View {
            HStack(alignment: .top, spacing: 16) {
                Group {
                    if let image = posterImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 90)
                            .clipped()
                    } else {
                        Image("placeholder")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 90)
                            .clipped()
                    }
                }
                
                // Title and Genres
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.title2)
                        .bold()
                        .lineLimit(2)
                        .foregroundColor(.white)
                    
                    
                    Text(movie.genres.map(\.name).joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
        }
    }
    
    // Movie Details View Component
    struct MovieDetailsView: View {
        var movie: DetailedMovie
        
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    MovieOverviewView(movie: movie)
                    Spacer()
                    MovieAdditionalInfoView(movie: movie)
                }
                .padding()
            }
        }
    }

    
    // Movie Overview View Component
    struct MovieOverviewView: View {
        var movie: DetailedMovie
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(movie.overview)
                    .foregroundColor(.white)
            }
        }
    }
    
    // Movie Additional Info View Component
    struct MovieAdditionalInfoView: View {
        var movie: DetailedMovie
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                if !movie.spokenLanguages.isEmpty {
                    Text("Spoken Languages: \(movie.spokenLanguages.map(\.englishName).joined(separator: ", "))")
                        .foregroundColor(.white)
                }
                HStack {
                    Text("Release Date: \(movie.releaseDate)")
                        .foregroundColor(.white)
                    Spacer()
                    Text("Runtime: \(movie.runtime ?? 0) minutes")
                        .foregroundColor(.white)
                }
                HStack {
                    if let budget = movie.budget {
                        Text("Budget: $\(budget)")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    if let revenue = movie.revenue {
                        Text("Revenue: $\(revenue)")
                            .foregroundColor(.white)
                    }
                }
                
                
                if let homepage = movie.homepage, let url = URL(string: homepage) {
                    Link("Visit Homepage", destination: url)
                        .foregroundColor(.blue)
                        .padding(.top, 4)
                }
            }.font(.caption)
        }
    }
    
    private var loadingView: some View {
        ProgressView("Loading...")
            .padding()
    }
    
    private func errorView(message: String) -> some View {
        Text("Error: \(message)")
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    private func onAppearAction() {
        viewModel.fetchMovieDetail(movieID: movieID)
    }
    
    private func onChangeAction(newMovieID: Int) {
        posterImage = nil
        viewModel.fetchMovieDetail(movieID: newMovieID)
    }
    
    private func fetchImage(from urlString: String) {
        viewModel.fetchImage(from: urlString) { image in
            self.posterImage = image
            print("Image loaded successfully")
        }
    }
}

#Preview {
    MovieDetailView(movieID: .constant(933263))
}
