//
//  PostsViewModel.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 10/07/25.
//



import SwiftUI
import Observation

/// ViewModel responsible for managing feed data and navigation for the `HomeView`.
@Observable
final class PostsViewModel {

    // MARK: - Dependencies

    private let topicsService: TopicsProtocol
    public let topic: Topic

    // MARK: - Feed State

    private(set) var posts: [Post] = []
    private(set) var isLoading: Bool = false
    private(set) var hasLoadedPosts: Bool = false
   
    // MARK: - Init

    init(
        topic: Topic,
        topicsService: TopicsProtocol = TopicsService()
    ) {
        self.topic = topic
        self.topicsService = topicsService
    }
    
    func fetchPosts() async {
        // Skip if already loaded or currently loading
        guard !hasLoadedPosts && !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }

        do {
            posts = try await topicsService.fetchPosts(for: topic.id)
            hasLoadedPosts = true
        } catch {
            print("❌ [PostsViewModel] Failed to load feed data: \(error.localizedDescription)")
        }
    }
    
}
