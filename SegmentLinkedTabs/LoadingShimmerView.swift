//
//  LoadingShimmerView.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 11/07/25.
//



import SwiftUI

/// A view that displays an animated linear gradient with shimmering effect
/// Supports both light and dark mode with appropriate colors
struct LoadingShimmerView: View {
    
    // MARK: - Animation Properties
    
    @State private var animationStartPoint: UnitPoint = .initialStartPoint
    @State private var animationEndPoint: UnitPoint = .initialEndPoint
    
    // MARK: - Configuration Properties
    
    private let gradientColors: [Color]
    private let animationDuration: TimeInterval
    private let animation: Animation
    
    // MARK: - Initializers
    
    /// Creates a shimmering gradient view
    /// - Parameters:
    ///   - baseColor: The base color for the gradient (will be adjusted for light/dark mode)
    ///   - animationDuration: Duration of one animation cycle (default: 1.0)
    init(baseColor: Color = .gray, animationDuration: TimeInterval = 1.0) {
        self.animationDuration = animationDuration
        self.animation = .easeInOut(duration: animationDuration).repeatForever(autoreverses: false)
        
        // Configure gradient colors based on color scheme
        let opacity: Double = 0.4
        self.gradientColors = [
            baseColor.opacity(opacity),
            Color.white.opacity(opacity),
            baseColor.opacity(opacity)
        ]
    }
    
    // MARK: - View Body
    
    var body: some View {
        LinearGradient(
            colors: gradientColors,
            startPoint: animationStartPoint,
            endPoint: animationEndPoint
        )
        .onAppear(perform: startAnimation)
        .onDisappear(perform: resetAnimation)
    }
    
    // MARK: - Animation Methods
    
    /// Starts the shimmer animation
    private func startAnimation() {
        withAnimation(animation) {
            animationStartPoint = .animatedStartPoint
            animationEndPoint = .animatedEndPoint
        }
    }
    
    /// Resets animation state (good practice when view disappears)
    private func resetAnimation() {
        animationStartPoint = .initialStartPoint
        animationEndPoint = .initialEndPoint
    }
}

// MARK: - UnitPoint Extensions

private extension UnitPoint {
    /// Initial position for the animation start point
    static let initialStartPoint = UnitPoint(x: -1.8, y: -1.2)
    /// Initial position for the animation end point
    static let initialEndPoint = UnitPoint(x: 0, y: -0.2)
    /// Animated position for the animation start point
    static let animatedStartPoint = UnitPoint(x: 1, y: 1)
    /// Animated position for the animation end point
    static let animatedEndPoint = UnitPoint(x: 2.2, y: 2.2)
}

// MARK: - Previews

#Preview {
        Group {
            LoadingShimmerView()
            LoadingShimmerView(baseColor: .blue)
            LoadingShimmerView(animationDuration: 2.0)
                
        }
        .frame(width: 300, height: 200)
    
}
