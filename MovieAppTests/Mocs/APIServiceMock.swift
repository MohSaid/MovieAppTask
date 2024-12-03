//
//  APIServiceMock.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 03/12/2024.
//

class MockAPIService: APIServiceProtocol {
    var result: Any?
    
    func GET<T>(endpoint: APIService.Endpoint, params: [String : String]?, completionHandler: @escaping (Result<T, APIService.APIError>) -> Void) where T : Decodable {
        if let result = self.result as? Result<T, APIService.APIError> {
            completionHandler(result)
        }
    }
}
