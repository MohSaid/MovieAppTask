//
//  Movie.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 30/11/2024.
//

import SwiftUI


struct MoviesResponse: Codable {
    let results: [Movie]
    let totalPages: Int?
    let page: Int?
    
    enum CodingKeys: String, CodingKey {
            case results
            case page
            case totalPages = "total_pages"
        }
}

struct Movie: Codable, Identifiable , Equatable {
    let id: Int
    let title: String
    let genreIDs: [Int]
    let releaseDate: String
    let posterPath: String?

    var releaseYear: String {
        String(releaseDate.prefix(4))
    }

    var posterURL: URL? {
        if let path = posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        }
        return nil
    }

    enum CodingKeys: String, CodingKey {
        case id, title
        case genreIDs = "genre_ids"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}
