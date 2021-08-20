//
//  article.swift
//  News
//
//  Created by user198890 on 7/28/21.
//

import Foundation

// API response model
// API response is returned in JSON format
struct APIResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// Article model
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

// Source sub-model
struct Source: Codable {
    let id: String?
    let name: String
}
