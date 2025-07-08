//
//  SegmentLinkedTabsApp.swift
//  SegmentLinkedTabs
//
//  Created by Swarajmeet Singh on 26/06/25.
//

import SwiftUI

@main
struct SegmentLinkedTabsApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel())
               // .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
