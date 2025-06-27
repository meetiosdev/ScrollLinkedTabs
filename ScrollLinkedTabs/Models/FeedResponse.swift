//
//  FeedResponse.swift
//  ScrollLinkedTabs
//
//  Created by Swarajmeet Singh on 26/06/25.
//


struct FeedResponse: Decodable {
    let pageNumber: Int
    let pageSize: Int
    let totalRecordCount: Int
    let nextPage: String?
    let records: [Topic]

    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_number"
        case pageSize = "page_size"
        case totalRecordCount = "total_record_count"
        case nextPage = "next_page"
        case records
    }
}
