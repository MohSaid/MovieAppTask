//
//  MovieDetail.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 02/12/2024.
//

import SwiftUI

struct DetailedMovie: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let originalTitle: String
    let tagline: String?
    let overview: String
    let releaseDate: String
    let runtime: Int?
    let voteAverage: Double
    let voteCount: Int
    let posterPath: String?
    let backdropPath: String?
    let budget: Int?
    let revenue: Int?
    let status: String
    let genres: [Genre]
    let spokenLanguages: [SpokenLanguage]
    let homepage: String?

    var posterURL: URL? {
        if let path = posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        }
        return nil
    }

    // Implementing the Equatable conformance manually
    static func == (lhs: DetailedMovie, rhs: DetailedMovie) -> Bool {
        return lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.originalTitle == rhs.originalTitle &&
            lhs.tagline == rhs.tagline &&
            lhs.overview == rhs.overview &&
            lhs.releaseDate == rhs.releaseDate &&
            lhs.runtime == rhs.runtime &&
            lhs.voteAverage == rhs.voteAverage &&
            lhs.voteCount == rhs.voteCount &&
            lhs.posterPath == rhs.posterPath &&
            lhs.backdropPath == rhs.backdropPath &&
            lhs.budget == rhs.budget &&
            lhs.revenue == rhs.revenue &&
            lhs.status == rhs.status &&
            lhs.genres == rhs.genres &&
            lhs.spokenLanguages == rhs.spokenLanguages &&
            lhs.homepage == rhs.homepage
    }

    enum CodingKeys: String, CodingKey {
        case id, title, tagline, overview, runtime, status, genres, homepage
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case budget, revenue
        case spokenLanguages = "spoken_languages"
    }
}

struct SpokenLanguage: Codable, Equatable {
    let englishName: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
    }

    // Conformance to Equatable
    static func == (lhs: SpokenLanguage, rhs: SpokenLanguage) -> Bool {
        return lhs.englishName == rhs.englishName
    }
}
