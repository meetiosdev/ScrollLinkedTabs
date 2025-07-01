//
//  SafeAreaManager.swift
//  ScrollLinkedTabs
//
//  Created by Swarajmeet Singh on 01/07/25.
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


// MARK: - UIApplication Extensions
extension UIApplication {
    /// Safely get the key window's safe area insets.
    var keyWindowInsets: UIEdgeInsets? {
        return self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first(where: { $0.isKeyWindow })?.safeAreaInsets
    }

}
