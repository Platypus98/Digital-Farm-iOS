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
    @State private var ip: String = UserDefaults.standard.object(forKey: "IP") as? String ?? ""
    @State private var port: String = UserDefaults.standard.object(forKey: "Port") as? String ?? ""
    
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
                    HStack {
                        Text("IP адрес:")
                        TextField("________", text: $ip) {
                            viewModel.saveIPAndPort(ip: ip, port: port)
                            UIApplication.shared.endEditing()
                        }
                    }
                    HStack {
                        Text("Порт:")
                        TextField("________", text: $port) {
                            viewModel.saveIPAndPort(ip: ip, port: port)
                            UIApplication.shared.endEditing()
                        }
                    }
                    Text(appSettings.text)
                        .multilineTextAlignment(.center)
                }
                    .padding()
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
