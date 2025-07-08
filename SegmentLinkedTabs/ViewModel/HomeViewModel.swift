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

    private let feedService: FeedServiceProtocol

    // MARK: - Feed State

    private(set) var topics: [Topic] = []
    private(set) var selectedTopic: Topic?
    private(set) var isLoading: Bool = false
    private var currentPage: Int = 0
    var selectedTabIndex: Int = 0

    // MARK: - UI State

    var headerHeight: CGFloat = 0
    let topicsBarHeight: CGFloat = 30
    let navigationBarHeight: CGFloat = 44
    private let headerPadding: CGFloat = 12

    // MARK: - Init

    init(feedService: FeedServiceProtocol = FeedService()) {
        self.feedService = feedService
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
            let response = try await feedService.fetchLocalFeed(page: currentPage + 1)
            topics.append(contentsOf: response.records)
            currentPage = response.pageNumber

            // Auto-select first topic if none selected
            if selectedTopic == nil, let first = topics.first {
                selectTopic(first)
            }

        } catch {
            print("❌ [HomeViewModel] Failed to load feed data: \(error.localizedDescription)")
        }
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
