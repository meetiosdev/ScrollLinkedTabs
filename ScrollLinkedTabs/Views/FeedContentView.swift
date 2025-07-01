//
//  FeedContentView.swift
//  ScrollLinkedTabs
//
//  Created by Swarajmeet Singh on 27/06/25.
//


import SwiftUI

/// Displays content for selected Topic
struct FeedContentView: View {
    @State private var viewModel: HomeViewModel
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        TabView(selection: $viewModel.selectedTabIndex) {
            ForEach(Array(viewModel.topics.enumerated()), id: \.element.id) { index, topic in
                PostsFeedView(topic: topic)
                    .tag(index)
            }
        }
        .ignoresSafeArea()
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: viewModel.selectedTabIndex) { _, newValue in
            if newValue < viewModel.topics.count {
                let topic = viewModel.topics[newValue]
                    viewModel.selectTopic(topic)
            }
        }
    }
}
