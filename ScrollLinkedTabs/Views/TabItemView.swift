//
//  TabItemView.swift
//  ScrollLinkedTabs
//
//  Created by Swarajmeet Singh on 27/06/25.
//



import SwiftUI

/// A reusable view that displays a single tab item for a Topic with selection animation.
struct TabItemView: View {

    // MARK: - Properties

    let topic: Topic
    let isActive: Bool
    let activeHighlightColor: Color
    let animationNamespace: Namespace.ID
    let height: CGFloat
    let onSelect: () -> Void

    // MARK: - Initializer

    init(
        topic: Topic,
        isActive: Bool,
        activeHighlightColor: Color = .purple,
        animationNamespace: Namespace.ID,
        height: CGFloat = 28,
        onSelect: @escaping () -> Void
    ) {
        self.topic = topic
        self.isActive = isActive
        self.activeHighlightColor = activeHighlightColor
        self.animationNamespace = animationNamespace
        self.height = height
        self.onSelect = onSelect
    }


    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            topicNameText
            Spacer()
        }
        .frame(height: height)
        .overlay(alignment: .bottom) {
            activeUnderline
        }
        .contentShape(.rect) // Ensures full tappable area
        .onTapGesture(perform: handleSelection)
    }

    // MARK: - Subviews

    /// The text view displaying the Topic name.
    private var topicNameText: some View {
        Text(topic.name.capitalized)
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(isActive ? Color.primary : Color.gray)
    }

    /// The underline that appears when the tab is selected.
    @ViewBuilder
    private var activeUnderline: some View {
        if isActive {
            activeHighlightColor
                .frame(height: 3)
                .clipShape(.capsule)
                .matchedGeometryEffect(id: "ACTIVE_TOPIC_TAB", in: animationNamespace)
        }
    }

    // MARK: - Actions

    /// Handles the selection of the tab.
    private func handleSelection() {
        guard !isActive else { return }
            onSelect()
    }
}

// MARK: - Preview

// MARK: - Preview

#Preview {
    struct TabItemViewPreview: View {
        @State private var selectedTopicID: Int = 0
        @Namespace private var animation

        private let topic = Topic(id: 0, name: "gaming", color: "#4A7B9D", posts: [])

        var body: some View {
            TabItemView(
                topic: topic,
                isActive: selectedTopicID == topic.id,
                activeHighlightColor: .purple,
                animationNamespace: animation
            ) {
                selectedTopicID = topic.id
                print("Selected Topic:", topic)
            }
            .padding()
            .background(Color.black)
        }
    }

    return TabItemViewPreview()
}
