//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 02/12/2024.
//

import SwiftUI
import Combine

class MovieDetailViewModel: ObservableObject {
    @Published var detailedMovie: DetailedMovie? 
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    private let imageService = ImageService.shared
        
    @Published var posterImage: UIImage?
    

    func fetchMovieDetail(movieID: Int) {
        isLoading = true
        errorMessage = nil

        APIService.shared.GET(endpoint: .movieDetail(movie: movieID), params: nil) { [weak self] (result: Result<DetailedMovie, APIService.APIError>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let movieDetail):
                    self.detailedMovie = movieDetail
                case .failure(let error):
                    self.errorMessage = self.handleError(error)
                }
            }
        }
    }

    
    func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        imageService.fetchImage(poster: urlString, size: .medium)
               .sink { completion($0) }
               .store(in: &cancellables)
       }
    
    
    private func handleError(_ error: APIService.APIError) -> String {
        switch error {
        case .noResponse:
            return "No response from the server."
        case .jsonDecodingError(let decodingError):
            return "Failed to decode response: \(decodingError.localizedDescription)"
        case .networkError(let networkError):
            return "Network error: \(networkError.localizedDescription)"
        }
    }
}

