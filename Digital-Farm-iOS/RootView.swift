//
//  ContentView.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.01.2022.
//

import Foundation
import SwiftUI

struct RootView: View {

    // MARK: - Body
    var body: some View {
        let appearance = Appearance()
        TabView {
            MainScreenView(viewModel: MainScreenViewModel(devicesService: DeviceService())).tabItem {
                Text(appearance.mainTabTitle)
            }
        }
    }
}

// MARK: - Appearance
private extension RootView {
    struct Appearance {
        let mainTabTitle = Localized("MainScreen.Title")
    }
}

