//
//  FeedViewModel.swift
//  ScrollLinkedTabs
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

    private(set) var sections: [Topic] = []
    private(set) var selectedSection: Topic?
    private(set) var isLoading: Bool = false
    private var currentPage: Int = 0
    var selectedTabIndex: Int = 0

    // MARK: - UI State

    var sectionBarHeight: CGFloat = 24

    // MARK: - Init

    init(feedService: FeedServiceProtocol = FeedService()) {
        self.feedService = feedService
    }

    // MARK: - Data Loading

    func initializeFeed() {
        guard sections.isEmpty, !isLoading else { return }
        Task { [weak self] in
            await self?.loadMoreSections()
        }
    }

    func loadMoreSections() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await feedService.fetchLocalFeed(page: currentPage + 1)
            sections.append(contentsOf: response.records)
            currentPage = response.pageNumber

            // Auto-select first section if none selected
            if selectedSection == nil, let first = sections.first {
                selectSection(first)
            }

        } catch {
            print("❌ [HomeViewModel] Failed to load feed data: \(error.localizedDescription)")
        }
    }

    // MARK: - Section Selection

    func selectSection(_ section: Topic) {
        guard let newIndex = sections.firstIndex(where: { $0.id == section.id }) else { return }

        if let current = selectedSection,
           let currentIndex = sections.firstIndex(where: { $0.id == current.id }) {
            let diff = abs(currentIndex - newIndex)
            withAnimation(diff > 3 ? nil : .snappy) {
                updateSelection(section, newIndex)
            }
        } else {
            updateSelection(section, newIndex)
        }
    }

    func isSectionSelected(_ section: Topic) -> Bool {
        selectedSection?.id == section.id
    }

    func clearSelection() {
        selectedSection = nil
        selectedTabIndex = 0
    }

    // MARK: - Helpers

    private func updateSelection(_ section: Topic, _ index: Int) {
        selectedSection = section
        selectedTabIndex = index
    }
}
