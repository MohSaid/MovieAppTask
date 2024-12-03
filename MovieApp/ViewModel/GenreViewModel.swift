//
//  genres.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 28/11/2024.
//

import SwiftUI
import Combine

class GenreViewModel: ObservableObject {
    @Published var genres: [Genre] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }

    func fetchGenres() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        apiService.GET(endpoint: .genres, params: [:]) { [weak self] (result: Result<GenresResponse, APIService.APIError>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.genres = response.genres
                case .failure(let error):
                    self.handleError(error)
                }
            }
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
