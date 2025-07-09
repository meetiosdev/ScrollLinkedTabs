//
//  CommunityListResponse.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 08/07/25.
//


import Foundation

/// Represents the top-level response from the community list API
struct CommunityListResponse: Codable {
    /// Response status code
    var responseCode: String
    
    /// Message describing the result of the request
    var message: String
    
    /// Container for community-related information
    var communitiesInfo: CommunitiesInfo
    
    private enum CodingKeys: String, CodingKey {
        case responseCode
        case message
        case communitiesInfo = "data"
    }
}

/// Container for the list of communities and pagination details
struct CommunitiesInfo: Codable {
    /// Collection of communities the user is part of
    var myCommunities: CommunityCollection
}

/// Collection of communities with pagination metadata
struct CommunityCollection: Codable {
    /// Array of communities
    var communities: [Topic]
    
    /// Total number of communities available
    var total: Int
    
    /// Current page number
    var page: Int
    
    /// Number of communities per page
    var perPage: Int
}
