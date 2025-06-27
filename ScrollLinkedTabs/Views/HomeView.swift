//
//  HomeView.swift
//  ScrollLinkedTabs
//
//  Created by Swarajmeet Singh on 27/06/25.
//


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
        FeedContentView(viewModel: viewModel)
            .overlay(alignment: .top) {
                headerMaterialBackground
                    .frame(height: 96)
                    .overlay(alignment: .bottom) {
                        TabsBarView(viewModel: viewModel)
                            .frame(height: 24)
                    }
                    .ignoresSafeArea(edges: .top)
            }
            .task {
                viewModel.initializeFeed()
            }
    }
    
    @ViewBuilder
    private var headerMaterialBackground: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .overlay(Divider(), alignment: .bottom)
    }
}
