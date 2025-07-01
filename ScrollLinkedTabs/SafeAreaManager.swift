//
//  SafeAreaManager.swift
//  Melpot
// Copyright © 2025 Suhub Armaa.
// This file is part of the Melpot. It contains essential code and logic that contributes to the overall functionality of the application.
//  Note: Unauthorized use, copying, or distribution of this code, in whole or in part, is strictly prohibited. This code is proprietary and should not be captured, stored, or used in any other application.
// All Rights Reserved.
//



import SwiftUI
import UIKit

// MARK: - SafeAreaManager
/// A manager to access safe area insets in a clean and reusable way.
struct SafeAreaManager {
    /// Get the top safe area inset.
    static var top: CGFloat {
        UIApplication.shared.keyWindowInsets?.top ?? 0
    }

    /// Get the bottom safe area inset.
    static var bottom: CGFloat {
        UIApplication.shared.keyWindowInsets?.bottom ?? 0
    }

    /// Get the left (leading) safe area inset.
    static var leading: CGFloat {
        UIApplication.shared.keyWindowInsets?.left ?? 0
    }

    /// Get the right (trailing) safe area inset.
    static var trailing: CGFloat {
        UIApplication.shared.keyWindowInsets?.right ?? 0
    }
}

// MARK: - NavigationBarManager
/// Access the navigation bar height in the current view hierarchy.
struct NavigationBarManager {
    static var height: CGFloat {
        UIApplication.shared.rootNavigationController?.navigationBar.frame.height ?? defaultHeight
    }

    private static var defaultHeight: CGFloat {
        UINavigationController().navigationBar.frame.height
    }
}

// MARK: - UIApplication Extensions
extension UIApplication {
    /// Safely get the key window's safe area insets.
    var keyWindowInsets: UIEdgeInsets? {
        return self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first(where: { $0.isKeyWindow })?.safeAreaInsets
    }

    /// Attempt to find the root tab bar controller from the key window.
    var rootTabBarController: UITabBarController? {
        return self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first(where: { $0.isKeyWindow })?
            .rootViewController as? UITabBarController
    }
    
    /// Find the root navigation controller if it exists.
    var rootNavigationController: UINavigationController? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first(where: \.isKeyWindow)?
            .rootViewController as? UINavigationController
    }
}
