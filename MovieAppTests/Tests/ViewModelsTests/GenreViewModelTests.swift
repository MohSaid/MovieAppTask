//
//  Untitled.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 03/12/2024.
//

import XCTest
@testable import MovieApp

class GenreViewModelTests: XCTestCase {
    
    var viewModel: GenreViewModel!
    var mockAPIService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = GenreViewModel(apiService: mockAPIService)
    }

    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }

    func testFetchGenresSuccess() {
       
        let mockGenres = [Genre(id: 1, name: "Action"), Genre(id: 2, name: "Comedy")]
        let mockResponse = GenresResponse(genres: mockGenres)

       
        mockAPIService.result = Result<GenresResponse, APIService.APIError>.success(mockResponse)

     
        viewModel.fetchGenres()

      
        let expectation = XCTestExpectation(description: "Fetch genres success")
        DispatchQueue.main.async {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.genres, mockGenres)
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchGenresFailure() {
      
        mockAPIService.result = Result<GenresResponse, APIService.APIError>.failure(.noResponse)

       
        viewModel.fetchGenres()

       
        let expectation = XCTestExpectation(description: "Fetch genres failure")
        DispatchQueue.main.async {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.errorMessage, "No response from the server.")
            XCTAssertTrue(self.viewModel.genres.isEmpty)  
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
