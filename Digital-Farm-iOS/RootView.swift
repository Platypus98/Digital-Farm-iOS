//
//  ContentView.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.01.2022.
//

import Foundation
import SwiftUI

struct RootView: View {
    
    @State var selectedTab: Tab = .home

    // MARK: - Body
    var body: some View {
        let appearance = Appearance()
        TabView(selection: $selectedTab) {
            MainScreenView(viewModel: MainScreenViewModel())
                .tag(Tab.home)
                .tabItem {
                    Image("home")
                        .renderingMode(.template)
                    Text(appearance.mainTabTitle).foregroundColor(.black)
                }
            
            AppSettingsView(viewModel: AppSettingsViewModel())
                .tag(Tab.info)
                .tabItem {
                    Image("info")
                        .renderingMode(.template)
                    Text(appearance.infoTabTitle).foregroundColor(.black)
                }
           
        }.accentColor(.secondary)
    }
}

// MARK: - Tabs
extension RootView {
    enum Tab: Hashable {
        case home
        case info
    }
}

// MARK: - Appearance
private extension RootView {
    struct Appearance {
        let mainTabTitle = Localized("MainScreen.Title")
        let infoTabTitle = Localized("MainScreen.Info")
    }
}
