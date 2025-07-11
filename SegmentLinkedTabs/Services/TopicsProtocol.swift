//
//  TopicsProtocol.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 10/07/25.
//


// MARK: - Protocols

/// Protocol defining the interface for topics service operations
protocol TopicsProtocol {
    /// Fetches topics with pagination support
    /// - Parameters:
    ///   - page: The page number to fetch (1-based)
    ///   - limit: Number of topics per page
    /// - Returns: TopicsResponse containing topics and pagination info
    func fetchTopics(page: Int, limit: Int) async throws -> TopicsResponse
    
    /// Fetches posts for a specific topic
    /// - Parameter topicId: The ID of the topic
    /// - Returns: Array of posts for the topic
    func fetchPosts(for topicId: String) async throws -> [Post]
}
