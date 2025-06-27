import SwiftUI

/// A scrollable feed view that displays either a list of post cards or placeholder colored rectangles.
/// - Displays actual posts if provided, otherwise renders a visual placeholder grid using a gradient color style.
struct PostsFeedView: View {
    
    // MARK: - Input
    
    let community : Community
    
    init(community: Community) {
        self.community = community
    }
    
    /// Placeholder generation bounds.
    private let placeholderRange = 1...25
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if let posts = community.posts {
                    renderPostList(posts)
                } else {
                    renderPlaceholderGrid()
                }
                
            }
        }
        .contentMargins(.vertical, 48)
        .scrollIndicators(.hidden)
    }
    
    // MARK: - Subviews
    
    /// Renders a list of post cards.
    /// - Parameter posts: The array of `Post` models to render.
    @ViewBuilder
    private func renderPostList(_ posts: [Post]) -> some View {
        ForEach(posts) { post in
            PostCardView(
                post: post,
                backGroundColor: Color(hex: community.color)
            )
        }
    }
    
    /// Renders a gradient-styled placeholder grid for loading state or demo.
    @ViewBuilder
    private func renderPlaceholderGrid() -> some View {
        ForEach(placeholderRange, id: \.self) { index in
            let fillOpacity = 1.0 - Double(index - placeholderRange.lowerBound) / Double(placeholderRange.count - 1)
            let borderOpacity = 1.0 - fillOpacity
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: community.color).opacity(fillOpacity))
                .frame(height: 84)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: community.color).opacity(borderOpacity), lineWidth: 1)
                )
                .overlay {
                    Text(String(format: "%.2f", fillOpacity))
                        .foregroundColor(.primary)
                        .font(.caption)
                }
                .padding(.horizontal, 16)
        }
    }
}