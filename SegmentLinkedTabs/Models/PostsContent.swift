//
//  PostsContent.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 10/07/25.
//


struct PostsContent: Codable {
    /// Information about the topic
    let topic: Topic
    
    /// List of posts related to the topic
    let posts: [Post]
    
    /// Total number of posts
    let postCount: Int
}
