//
//  TopicsService.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 10/07/25.
//

import Foundation


// MARK: - Service Implementation

/// Service responsible for fetching topics and posts from the API

final class TopicsService: TopicsProtocol {
    private let baseURL = "http://localhost:3000" //"https://topics-api.onrender.com"//
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchTopics(page: Int, limit: Int) async throws -> TopicsResponse {
        let url = URL(string: "\(baseURL)/api/topics?page=\(page)&limit=\(limit)")!
        
        let (data, response) = try await session.data(from: url)
        print(data.json)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TopicsError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw TopicsError.httpError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(TopicsResponse.self, from: data)
        } catch {
            print(error)
            throw TopicsError.decodingError(error)
        }
    }
    
    func fetchPosts(for topicId: String) async throws -> [Post] {
        let url = URL(string: "\(baseURL)/api/topics/\(topicId)/posts")!
        
        let (data, response) = try await session.data(from: url)
        print(data.json)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TopicsError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw TopicsError.httpError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let postsResponse = try decoder.decode(PostsResponse.self, from: data)
            return postsResponse.content.posts
        } catch {
            print(error)
            throw TopicsError.decodingError(error)
        }
    }
}

/// Custom error types for topics operations
enum TopicsError: LocalizedError {
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
