//
//  PostView.swift
//  ScrollLinkedTabs
//
//  Created by Swarajmeet Singh on 27/06/25.
//


import SwiftUI

/// A view that displays a social media-style post card with user name, content, date, and likes.
struct PostView: View {
    
    // MARK: - Input
    let post: Post
    let backGroundColor: Color
    
    init(
        post: Post,
        backGroundColor: Color = .gray.opacity(0.1)
    ) {
        self.post = post
        self.backGroundColor = backGroundColor
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerSection
            contentSection
            footerSection
        }
        .padding()
        .background(backGroundColor.opacity(0.5))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
    
    // MARK: - Components
    
    /// Displays the post header with user name and formatted date.
    private var headerSection: some View {
        HStack {
            Text(post.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(formattedDate(from: post.date))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    /// Displays the main content of the post.
    private var contentSection: some View {
        Text(post.content)
            .font(.body)
            .foregroundColor(.primary)
    }
    
    /// Displays the footer with likes and icon.
    private var footerSection: some View {
        HStack(spacing: 4) {
            Image(systemName: "hand.thumbsup.fill")
                .foregroundColor(.blue)
                .font(.subheadline)
            
            Text("\(post.likes) Likes")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Helpers
    
    /// Formats a `Date` into a readable string.
    /// - Parameter date: The `Date` to format.
    /// - Returns: A formatted date string.
    private func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
