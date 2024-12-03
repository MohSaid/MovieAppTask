//
//  Untitled.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 03/12/2024.
//

import XCTest
@testable import MovieApp

// Mock APIService to simulate API responses
class MockAPIService: APIServiceProtocol {
   
    var result: Any?
    
    func GET<T>(endpoint: APIService.Endpoint, params: [String : String]?, completionHandler: @escaping (Result<T, APIService.APIError>) -> Void) where T : Decodable {
        if let result = self.result as? Result<T, APIService.APIError> {
            completionHandler(result)
        }
    }
}

class MovieViewModelTests: XCTestCase {
    
    var viewModel: MovieViewModel!
    var mockAPIService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = MovieViewModel(apiService: mockAPIService)
    }

    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }

    func testFetchMovies() {
        
        let mockMovies = [
            Movie(id: 1, title: "Action Movie", genreIDs: [1], releaseDate: "2024-01-01", posterPath: "/path1.jpg"),
            Movie(id: 2, title: "Comedy Movie", genreIDs: [2], releaseDate: "2024-02-01", posterPath: "/path2.jpg")
        ]
        
        
        let mockResponse = MoviesResponse(results: mockMovies, totalPages: 1, page: 1)
        
        
        mockAPIService.result = Result<MoviesResponse, APIService.APIError>.success(mockResponse)
        
        
        viewModel.fetchMovies(for: nil)

        
        let expectation = XCTestExpectation(description: "Fetch movies success")
        DispatchQueue.main.async {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.allMovies.count, 2)
            XCTAssertEqual(self.viewModel.movies.count, 2)
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchMoviesWithError() {
        
        let mockError = APIService.APIError.networkError(error: NSError(domain: "", code: 0, userInfo: nil))
        
        
        mockAPIService.result = Result<MoviesResponse, APIService.APIError>.failure(mockError)
        
        
        viewModel.fetchMovies(for: nil)
        
        
        let expectation = XCTestExpectation(description: "Fetch movies failure")
        DispatchQueue.main.async {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.errorMessage, "Network error: The operation couldn’t be completed. ( error 0.)")
            XCTAssertTrue(self.viewModel.allMovies.isEmpty)
            XCTAssertTrue(self.viewModel.movies.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
