//
//  FeedServiceProtocol.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 26/06/25.
//


// MARK: - Protocol

/// Protocol defining local feed fetching service
protocol FeedServiceProtocol {
    /// Loads a local paginated feed JSON file and decodes it
    /// - Parameter page: The page number to fetch
    /// - Returns: A decoded feed page response
    func fetchLocalFeed(page: Int) async throws -> FeedResponse
}
