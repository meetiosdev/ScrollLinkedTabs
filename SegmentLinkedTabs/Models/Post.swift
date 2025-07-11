//
//  Post.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 26/06/25.
//

import Foundation


struct Post: Codable, Identifiable {
    /// Internal database ID (Mongo-style)
    let internalId: String
    
    /// Public UUID for the post
    let id: UUID
    
    /// Name of the user who created the post
    let name: String
    
    /// Number of likes on the post
    let likes: Int
    
    /// Text content of the post
    let content: String
    
    /// Date when the post was created
    let date: Date
    
    private enum CodingKeys: String, CodingKey {
        case internalId = "_id"
        case id
        case name
        case likes
        case content
        case date
    }
}

