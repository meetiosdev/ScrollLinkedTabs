//
//  Post.swift
//  ScrollLinkedTabs
//
//  Created by Swarajmeet Singh on 26/06/25.
//

import Foundation

struct Post: Identifiable, Decodable, Hashable {
    let id: String
    let name: String
    let likes: Int
    let content: String
    let date: Date
}
