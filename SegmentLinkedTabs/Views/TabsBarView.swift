//
//  TabsBarView.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 27/06/25.
//



import SwiftUI

struct TabsBarView: View {
    
    // MARK: - State & Dependencies
    
    let viewModel: HomeViewModel
    @Namespace private var animation
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                if viewModel.topics.isEmpty && viewModel.isLoading {
                    loadingShimmer(count: 6)
                } else {
                    // FIXME: Using HStack to ensure stable view identities for smooth matchedGeometryEffect animations.
                    // LazyHStack is ideal for performance with large datasets but can break animations due to view reuse.
                    // See commented-out LazyHStack below for a fix that prevents animation issues while keeping performance benefits.
                    LazyHStack(spacing: 24) {
                        //HStack(spacing: 24) {
                        ForEach(viewModel.topics, id: \ .id) { topic in
                            TabItemView(
                                topic: topic,
                                isActive: viewModel.isTopicSelected(topic),
                                animationNamespace: animation,
                                height: viewModel.topicsBarHeight
                            ) {
                                viewModel.selectTopic(topic)
                            }
                            .id(topic.id)
                            .onAppear {
                                handlePagination(for: topic)
                            }
                        }
                        
                        if viewModel.isPaging {
                            loadingShimmer(count: 3)
                        }
                    }
                }
                
            }
            .contentMargins(.horizontal, 16)
            .onChange(of: viewModel.selectedTopic) { oldValue, topic in
                guard let topic = topic else { return }
                withAnimation {
                    scrollProxy.scrollTo(topic.id, anchor: .center)
                }
            }
        }
    }
    
    
    private func loadingShimmer(count: Int) -> some View {
        LazyHStack(spacing: 24) {
            ForEach(0..<count, id: \.self) { index in
                LoadingShimmerView()
                    .frame(width: CGFloat.random(in: 80...120), height: 20)
                    .clipShape(.rect(cornerRadius: 4))
                    .offset(y: -3)
            }
        }
    }
    private func handlePagination(for topic: Topic) {
        if viewModel.shouldLoadMore(for: topic) {
            Task {
                await viewModel.loadMoreTopics()
            }
        }
    }
    
}

#Preview {
    TabsBarView(viewModel: HomeViewModel())
        .padding()
}
