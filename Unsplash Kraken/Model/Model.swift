//
//  Model.swift
//  Unsplash The Kraken
//
//  Created by William Santoso on 24/11/20.
//

import Foundation


// MARK: - ImageData
struct ImageData: Codable {
    var totalPages: Int
    var results: [Result]
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct Result: Codable, Identifiable {
    var id: String
    var urls: Urls
    var likes: Int
    var resultDescription: String?
    var user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case likes
        case resultDescription = "description"
        case urls
        case user
    }
}

// MARK: - Urls
struct Urls: Codable {
    var raw, full, regular, small: String
    var thumb: String
}

// MARK: - User
struct User: Codable {
    var id: String
    var name: String
    var portfolioURL: String?
    var profileImage: ProfileImage
    var instagramUsername: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case portfolioURL = "portfolio_url"
        case profileImage = "profile_image"
        case instagramUsername = "instagram_username"
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    var small, medium, large: String
}
