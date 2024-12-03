//
//  APIServiceProtocol.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 03/12/2024.
//

internal protocol APIServiceProtocol {
    func GET<T: Codable>(
        endpoint: APIService.Endpoint,
        params: [String: String]?,
        completionHandler: @escaping (Result<T, APIService.APIError>) -> Void
    )
}
