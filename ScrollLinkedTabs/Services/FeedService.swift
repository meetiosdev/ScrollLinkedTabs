//
//  FeedService.swift
//  ScrollLinkedTabs
//
//  Created by Swarajmeet Singh on 26/06/25.
//

import Foundation


final class FeedService: FeedServiceProtocol {

    func fetchLocalFeed(page: Int) async throws -> FeedResponse {
        let fileName = "feed-page-\(page)" // Ensure files are named like feed-page-1.json
        print("📄 [Local Load] Fetching feed data from: \(fileName).json")

        // Try to locate the JSON file in the bundle
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw NSError(
                domain: "LocalFileError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "File \(fileName).json not found in bundle"]
            )
        }

        let data = try Data(contentsOf: url)

        // Debug: Pretty-print JSON if possible
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print("📦 [Local JSON - Page \(page)]:\n\(prettyString)")
        } else {
            print("⚠️ [Logger Warning] Unable to pretty print JSON.")
        }

        // Decode the JSON into your model
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decoded = try decoder.decode(FeedResponse.self, from: data)
            print("✅ [Decoding] Successfully decoded FeedPageResponse for page \(page)")
            return decoded
        } catch {
            print("❌ [Decoding Error] Failed to decode FeedPageResponse: \(error.localizedDescription)")
            throw error
        }
    }
}
