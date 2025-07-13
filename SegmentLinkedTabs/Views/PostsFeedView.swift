//
//  PostsFeedView.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 27/06/25.
//


import SwiftUI

/// A scrollable feed view that displays either a list of post cards or placeholder colored rectangles.
/// - Displays actual posts if provided, otherwise renders a visual placeholder grid using a gradient color style.
struct PostsFeedView: View {
    
    private let topicsBarHeight: CGFloat = 30
    private let navigationBarHeight: CGFloat = 44
    private let headerPadding: CGFloat = 12
    
    // MARK: - Input
    
    let viewModel: PostsViewModel
    let homeViewModel: HomeViewModel
    @State private var hasAppeared: Bool = false
    
    // MARK: - Init
    init(viewModel: PostsViewModel, homeViewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.homeViewModel = homeViewModel
    }
    
    /// Placeholder generation bounds.
    private let placeholderRange = 1...25
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if viewModel.posts.isEmpty {
                    renderPlaceholderGrid()
                } else {
                    renderPostList(viewModel.posts)
                }
              
            }
        }
        .contentMargins(.vertical, navigationBarHeight +  topicsBarHeight + headerPadding + 8)
        .scrollIndicators(.hidden)
        .onAppear {
            // Only fetch posts if this is the first time the view appears
            if !hasAppeared {
                hasAppeared = true
                Task {
                    await viewModel.fetchPosts()
                    homeViewModel.markTopicAsLoaded(viewModel.topic)
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    /// Renders a list of post cards.
    /// - Parameter posts: The array of `Post` models to render.
    @ViewBuilder
    private func renderPostList(_ posts: [Post]) -> some View {
        ForEach(posts) { post in
            PostView(
                post: post,
                backGroundColor: Color(hex: viewModel.topic.color)
            )
        }
    }
    
    // Renders a gradient-styled placeholder grid for loading state or demo.
    @ViewBuilder
    private func renderPlaceholderGrid() -> some View {
        ForEach(placeholderRange, id: \.self) { index in
            LoadingShimmerView(baseColor: Color(hex: viewModel.topic.color))
                .frame(height: 84)
                .clipShape(.rect(cornerRadius: 8))
                .padding(.horizontal, 16)
                
        }
    }
}
