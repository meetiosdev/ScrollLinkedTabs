//
//  CommunityService.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 08/07/25.
//

import Foundation


/// Protocol defining the community fetching service.
protocol CommunityProtocol {
    /// Fetches communities for the specified page.
    /// - Parameters:
    ///   - page: The page number to fetch (starting from 1).
    /// - Returns: A tuple containing the communities and the total count.
    /// - Throws: A `CommunityServiceError` if the request fails.
    func fetchCommunities(page: Int) async throws -> CommunityCollection
}

/// Service to fetch communities from the API.
struct CommunityService: CommunityProtocol {
    private let baseURL = URL(string: "https://dev.melpotapp.de/community/list")!
    private let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTYzMDUsInVzZXJJZCI6MjA1ODcsImVtYWlsIjoic0BtYWlsaW5hdG9yLmNvbSIsInVzZXJuYW1lIjoicm9iIiwic2Vzc2lvbklkIjoiMmI2MTA0NTMtNzdkMS00MWE3LWEyZmEtNTEzNTg2YTZlNmQ5IiwidWRpZCI6Ijg1ODM3M0ZFLUFBMUMtNDYwMi04OTM3LUE3ODgxNjZBNTg5Ri1EMDBDODg4Qi0zMzIzLTRDNjItODAyOC1CODUyMUNGN0Q5MkEiLCJzdGFydFRpbWUiOiIyMDI1LTA3LTA4VDE2OjAxOjAxLjkwOVoiLCJpYXQiOjE3NTE5OTA0NjEsImV4cCI6MTc1MjAwMTI2MX0._hytUWCgkovq7N4lZ4IeQyaftW0qKYKOEn3KSZmiC9A"
    
    func fetchCommunities(page: Int) async throws -> CommunityCollection {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "perPage", value: "\(5)"),
            URLQueryItem(name: "communityType", value: "1")
        ]
        
        guard let url = components?.url else {
            throw CommunityServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue("en", forHTTPHeaderField: "accept-language")
        request.setValue(accessToken, forHTTPHeaderField: "access_token")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CommunityServiceError.serverError(statusCode: -1)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw CommunityServiceError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let communityResponse = try decoder.decode(CommunityListResponse.self, from: data)
            return communityResponse.communitiesInfo.myCommunities
        } catch {
            throw CommunityServiceError.decodingError(error)
        }
    }
}

// MARK: - Service Protocol and Implementation

/// Errors that can occur during community fetching.
enum CommunityServiceError: LocalizedError {
    case invalidURL
    case serverError(statusCode: Int)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .serverError(let statusCode):
            return "Server error (status code: \(statusCode))."
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)."
        }
    }
}
