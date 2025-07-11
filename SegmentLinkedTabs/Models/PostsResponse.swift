//
//  PostsResponse.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 10/07/25.
//


struct PostsResponse: Codable {
    /// Indicates whether the API call was successful
    let success: Bool
    
    /// Topic and associated post content
    let content: PostsContent
    
    private enum CodingKeys: String, CodingKey {
        case success
        case content = "data"
    }
}
