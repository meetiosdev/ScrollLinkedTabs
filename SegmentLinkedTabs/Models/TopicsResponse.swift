//
//  TopicsResponse.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 26/06/25.
//


import Foundation

/// Top-level response object for paginated topics API
struct TopicsResponse: Codable {
    /// Indicates whether the API call was successful
    let success: Bool

    /// Array of topic items
    let topics: [Topic]

    /// Pagination metadata
    let pagination: PaginationInfo

    private enum CodingKeys: String, CodingKey {
        case success
        case topics = "data"
        case pagination
    }

}

/// Metadata for paginated responses
struct PaginationInfo: Codable {
    /// Current page number
    let currentPage: Int

    /// Total number of pages
    let totalPages: Int

    /// Total number of topics available
    let totalTopics: Int

    /// Indicates if there is a next page
    let hasNextPage: Bool

    /// Indicates if there is a previous page
    let hasPrevPage: Bool
}
