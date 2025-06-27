import SwiftUI

/// The main home screen view displaying content and a custom header.
struct HomeView: View {
    
    // MARK: - Properties
    @State private var viewModel: HomeViewModel
    
    // MARK: - Init
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        CommunityContentView(viewModel: viewModel)
            .overlay(alignment: .top) {
                headerMaterialBackground
                    .frame(height: 96)
                    .overlay(alignment: .bottom) {
                        CommunityTabsView(viewModel: viewModel)
                            .frame(height: 24)
                    }
                    .ignoresSafeArea(edges: .top)
            }
            .task {
                viewModel.initializeCommunities()
            }
    }
    
    @ViewBuilder
    private var headerMaterialBackground: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .overlay(Divider(), alignment: .bottom)
    }
}