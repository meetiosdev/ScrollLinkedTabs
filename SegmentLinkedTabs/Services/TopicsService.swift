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
    private let baseURL =  "http://localhost:3000" // "https://topics-api.onrender.com"//
    private let session: URLSession
    private let loadingDelay: UInt64 = 3 * 1_000_000_000  // 3 seconds

    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchTopics(page: Int, limit: Int) async throws -> TopicsResponse {
        try await Task.sleep(nanoseconds: loadingDelay)
        let url = URL(string: "\(baseURL)/api/topics?page=\(page)&limit=\(limit)")!
        
        // Log the request
        let requestId = APILogger.logRequest(
            url: url.absoluteString,
            method: "GET",
            headers: nil
        )
        
        let startTime = Date()
        
        do {
            let (data, response) = try await session.data(from: url)
            let responseTime = Date().timeIntervalSince(startTime)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = TopicsError.invalidResponse
                _ = APILogger.logError(
                    requestId: requestId,
                    data: nil,
                    statusCode: nil,
                    error: error,
                    responseTime: responseTime
                )
                throw error
            }
            
            // Log the response
            APILogger.logResponse(
                requestId: requestId,
                data: data,
                statusCode: httpResponse.statusCode,
                responseTime: responseTime
            )
            
            guard httpResponse.statusCode == 200 else {
                let error = TopicsError.httpError(statusCode: httpResponse.statusCode)
                _ = APILogger.logError(
                    requestId: requestId,
                    data: data,
                    statusCode: httpResponse.statusCode,
                    error: error,
                    responseTime: responseTime
                )
                throw error
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(TopicsResponse.self, from: data)
        } catch let error as TopicsError {
            throw error
        } catch {
            let responseTime = Date().timeIntervalSince(startTime)
            let topicsError = TopicsError.decodingError(error)
            _ = APILogger.logError(
                requestId: requestId,
                data: nil,
                statusCode: nil,
                error: topicsError,
                responseTime: responseTime
            )
            throw topicsError
        }
    }
    
    func fetchPosts(for topicId: String) async throws -> [Post] {
        try await Task.sleep(nanoseconds: loadingDelay)
        let url = URL(string: "\(baseURL)/api/topics/\(topicId)/posts")!
        
        // Log the request
        let requestId = APILogger.logRequest(
            url: url.absoluteString,
            method: "GET",
            headers: nil
        )
        
        let startTime = Date()
        
        do {
            let (data, response) = try await session.data(from: url)
            let responseTime = Date().timeIntervalSince(startTime)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = TopicsError.invalidResponse
                _ = APILogger.logError(
                    requestId: requestId,
                    data: nil,
                    statusCode: nil,
                    error: error,
                    responseTime: responseTime
                )
                throw error
            }
            
            // Log the response
            APILogger.logResponse(
                requestId: requestId,
                data: data,
                statusCode: httpResponse.statusCode,
                responseTime: responseTime
            )
            
            guard httpResponse.statusCode == 200 else {
                let error = TopicsError.httpError(statusCode: httpResponse.statusCode)
                _ = APILogger.logError(
                    requestId: requestId,
                    data: data,
                    statusCode: httpResponse.statusCode,
                    error: error,
                    responseTime: responseTime
                )
                throw error
            }
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let postsResponse = try decoder.decode(PostsResponse.self, from: data)
            return postsResponse.content.posts
        } catch let error as TopicsError {
            throw error
        } catch {
            let responseTime = Date().timeIntervalSince(startTime)
            let topicsError = TopicsError.decodingError(error)
            _ = APILogger.logError(
                requestId: requestId,
                data: nil,
                statusCode: nil,
                error: topicsError,
                responseTime: responseTime
            )
            throw topicsError
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
