//
//  Topic.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 26/06/25.
//


struct Topic: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let color: String
    let posts: [Post]?
}
