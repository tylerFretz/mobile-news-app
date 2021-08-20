//
//  ArticlesAPI.swift
//  News
//
//  Created by user198890 on 8/4/21.
//

import Foundation

// base News API url
let baseURL = "https://newsapi.org/v2/"
// api key saved as env variable
let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""

// Dictionary that matches each country that the News API has endpoints for with its respective country code
let countryCodes = [
    "Argentina": "ar",
    "Australia": "au",
    "Austria": "at",
    "Belgium": "be",
    "Brazil": "br",
    "Bulgaria": "bg",
    "Canada": "ca",
    "China": "cn",
    "Colombia": "co",
    "Cuba": "cu",
    "Egypt": "eg",
    "France": "fr",
    "Germany": "de",
    "Greece": "gr",
    "Hungary": "hu",
    "India": "in",
    "Indonesia": "id",
    "Ireland": "ie",
    "Israel": "il",
    "Italy": "it",
    "Japan": "jp",
    "Netherlands (the)": "nl",
    "New Zealand": "nz",
    "Russian Federation (the)": "ru",
    "Saudi Arabia": "sa",
    "Singapore": "sg",
    "South Africa": "za",
    "Switzerland": "ch",
    "Taiwan": "tw",
    "Turkey": "tr",
    "United States of America (the)": "us",
    "Venezuela (Bolivarian Republic of)": "ve"
]

// class that holds functions which query the News API
public class ArticlesAPI {

    // fetches news articles from the News API by using saved UserDefaults
    // for the country and category parameters
    func fetchArticles(completion: @escaping ([Article]) -> ()) {
        var queryUrl = baseURL + "top-headlines?"
        
        // if country is selected, add country to query
        if let country = UserDefaults.standard.string(forKey: "country") {
            queryUrl += "country=\(countryCodes[country] ?? "ca")"
        } else {
            queryUrl += "country=ca"
        }
        
        // if category is selected, add category to query
        if let category = UserDefaults.standard.string(forKey: "category") {
            queryUrl += "&category=\(category)"
        }
        queryUrl += "&apiKey=\(apiKey)"
        
        // async fetch articles from the News API
        guard let url = URL(string: queryUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let news = try! JSONDecoder().decode(APIResponse.self, from: data!)
            
            DispatchQueue.main.async {
                completion(news.articles)
            }
        }
        .resume()
    }
    
    // Fetches news articles from the News API that match the text in the search bar
    func queryArticlesByKeyword(keyword: String, completion: @escaping([Article]) -> ()) {
        // query url based on keyword user inputed into search bar
        let queryURL = "\(baseURL)everything?q=\(keyword)&apiKey=\(apiKey)"
        guard let url = URL(string: queryURL) else { return }
        
        // async fetch articles from the News API
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let news = try! JSONDecoder().decode(APIResponse.self, from: data!)
            
            DispatchQueue.main.async {
                completion(news.articles)
            }
        }
        .resume()
    }
}
