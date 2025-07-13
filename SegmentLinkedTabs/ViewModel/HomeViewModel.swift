//
//  FeedViewModel.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 26/06/25.
//

import SwiftUI
import Observation

/// ViewModel responsible for managing feed data and navigation for the `HomeView`.
@Observable
final class HomeViewModel {

    // MARK: - Dependencies

    private let topicsService: TopicsProtocol

    // MARK: - Feed State

    private(set) var topics: [Topic] = []
    private(set) var selectedTopic: Topic?
    private(set) var isLoading: Bool = false
    private var currentPage: Int = 0
    var selectedTabIndex: Int = 0
    private var totalCount: Int = 0
    private let pageSize: Int = 5

    // MARK: - Posts Cache
    
    private var postsViewModels: [String: PostsViewModel] = [:]
    private var loadedTopicIds: Set<String> = []

    // MARK: - UI State

    var headerHeight: CGFloat = 0
    let topicsBarHeight: CGFloat = 30
    let navigationBarHeight: CGFloat = 44
    private let headerPadding: CGFloat = 12

    // MARK: - Init

    init(topicsService: TopicsProtocol = TopicsService()) {
        self.topicsService = topicsService
        headerHeight = SafeAreaManager.top + navigationBarHeight + topicsBarHeight + headerPadding
    }

    // MARK: - Data Loading

    func initializeFeed() {
        guard topics.isEmpty, !isLoading else { return }
        Task { [weak self] in
            await self?.loadMoreTopics()
        }
    }

    func loadMoreTopics() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await topicsService.fetchTopics(page: currentPage + 1, limit: pageSize)
            let uniqueNew = response.topics.filter { new in
                !topics.contains { $0.id == new.id }
            }
            
            topics.append(contentsOf: uniqueNew)
            currentPage = response.pagination.currentPage
            totalCount = response.pagination.totalTopics
            
            if selectedTopic == nil, let first = topics.first {
                selectTopic(first)
            }

        } catch {
            print("❌ [HomeViewModel] Failed to load feed data: \(error.localizedDescription)")
        }
    }
    
    func shouldLoadMore(for topic: Topic) -> Bool {
        guard let index = topics.firstIndex(where: { $0.id == topic.id }) else { return false }
        return index >= topics.count - 2 && topics.count < totalCount
    }

    // MARK: - Posts ViewModel Management
    
    func getPostsViewModel(for topic: Topic) -> PostsViewModel {
        // Return cached PostsViewModel if it exists
        if let cachedViewModel = postsViewModels[topic.id] {
            return cachedViewModel
        }
        
        // Create new PostsViewModel and cache it
        let newViewModel = PostsViewModel(topic: topic, topicsService: topicsService)
        postsViewModels[topic.id] = newViewModel
        return newViewModel
    }
    
    func isTopicLoaded(_ topic: Topic) -> Bool {
        return loadedTopicIds.contains(topic.id)
    }
    
    func markTopicAsLoaded(_ topic: Topic) {
        loadedTopicIds.insert(topic.id)
    }

    // MARK: - Topic Selection

    func selectTopic(_ topic: Topic) {
        guard let newIndex = topics.firstIndex(where: { $0.id == topic.id }) else { return }

        if let current = selectedTopic,
           let currentIndex = topics.firstIndex(where: { $0.id == current.id }) {
            let diff = abs(currentIndex - newIndex)
            withAnimation(diff > 3 ? nil : .snappy) {
                updateSelection(topic, newIndex)
            }
        } else {
            updateSelection(topic, newIndex)
        }
    }

    func isTopicSelected(_ topic: Topic) -> Bool {
        selectedTopic?.id == topic.id
    }

    func clearSelection() {
        selectedTopic = nil
        selectedTabIndex = 0
    }

    // MARK: - Helpers

    private func updateSelection(_ topic: Topic, _ index: Int) {
        selectedTopic = topic
        selectedTabIndex = index
    }
}
