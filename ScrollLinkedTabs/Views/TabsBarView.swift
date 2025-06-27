//
//  TabsBarView.swift
//  ScrollLinkedTabs
//
//  Created by Swarajmeet Singh on 27/06/25.
//



import SwiftUI

struct TabsBarView: View {

    // MARK: - State & Dependencies

    @State private var viewModel: HomeViewModel
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
                    LazyHStack(spacing: 24) {
                        ForEach(viewModel.topics, id: \ .id) { topic in
                            TabItemView(
                                topic: topic,
                                isActive: viewModel.isTopicSelected(topic),
                                animationNamespace: animation
                            ) {
                                viewModel.selectTopic(topic)
                            }
                            .id(topic.id)
                        }
                    }
                   // .padding(.horizontal, 16)
                   // .redacted(reason: viewModel.communities.isEmpty ? .placeholder : [])
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
                Color.gray
                    .frame(width: CGFloat.random(in: 80...120), height: 20)
                    .clipShape(.rect(cornerRadius: 4))
                    .offset(y: -3)
            }
        }
    }
}
