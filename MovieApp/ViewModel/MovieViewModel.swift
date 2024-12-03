//
//  MoviesViewModel.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 01/12/2024.
//

import SwiftUI
import Combine

class MovieViewModel: ObservableObject {
    @Published var allMovies: [Movie] = []
    @Published var movies: [Movie] = [] // Filtered movies displayed in the UI
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var currentPage: Int = 1
    @Published var totalPages: Int = 1
    @Published var searchText: String = "" {
        didSet {
            filterMovies()
        }
    }

    private var apiService: APIServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    /// Initialize with dependency injection for the API service.
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    func fetchMovies(for genreId: Int?, reset: Bool = false) {
        guard !isLoading else { return }

        if reset {
            currentPage = 1
            allMovies = []
            movies = []
            totalPages = 1
        } else if currentPage > totalPages {
            return
        }

        isLoading = true
        errorMessage = nil
        
        var params: [String: String] = ["page": "\(currentPage)"]
        if let genreId = genreId {
            params["with_genres"] = "\(genreId)"
        }
        
        apiService.GET(endpoint: .discover, params: params) { [weak self] (result: Result<MoviesResponse, APIService.APIError>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.totalPages = response.totalPages ?? 1
                    if reset {
                        self.allMovies = response.results
                    } else {
                        self.allMovies.append(contentsOf: response.results)
                    }
                    self.filterMovies() // Filter the updated list of movies
                    self.currentPage += 1
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
    func filterMovies(for genreId: Int? = nil) {
        if let genreId = genreId {
            movies = allMovies.filter { $0.genreIDs.contains(genreId) }
        } else {
            movies = allMovies
        }
        
        if !searchText.isEmpty {
            movies = movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private func handleError(_ error: APIService.APIError) {
        switch error {
        case .noResponse:
            errorMessage = "No response from the server."
        case .jsonDecodingError(let decodingError):
            errorMessage = "Failed to decode data: \(decodingError.localizedDescription)"
        case .networkError(let networkError):
            errorMessage = "Network error: \(networkError.localizedDescription)"
        }
    }
}
