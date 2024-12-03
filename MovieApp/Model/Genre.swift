//
//  GenreModel.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 28/11/2024.
//

import SwiftUI

struct GenresResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
}
