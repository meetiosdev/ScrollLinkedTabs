//
//  Topic.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 26/06/25.
//


struct Topic: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let color: String?
    let posts: [Post]?
}

