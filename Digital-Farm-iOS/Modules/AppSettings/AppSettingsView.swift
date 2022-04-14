//
//  AppSettingsView.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 14.04.2022.
//

import SwiftUI

struct AppSettingsView<ViewModel: AppSettingsViewModel>: View {
    
    // MARK: - Private properties
    @ObservedObject private var viewModel: ViewModel
    private let appearance = Appearance()
    
    // MARK: - Init
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Content
    var body: some View {
        content.navigationTitle(appearance.title)
        .onAppear(perform: {
            viewModel.fetchSettings()
        })
    }
    
    private var content: some View {
        switch viewModel.state {
        case .loading:
            return AnyView(ProgressView())
        case .loaded(let appSettings):
            return AnyView(
                VStack {
                    Text(appSettings.text)
                        .multilineTextAlignment(.center)
                }
            )
        }
    }
}

// MARK: - Appearance

private extension AppSettingsView {
    struct Appearance {
        let title = Localized("AppSettings.Title")
    }
}
