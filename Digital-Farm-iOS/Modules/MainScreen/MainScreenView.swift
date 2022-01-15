//
//  MainScreenView.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.01.2022.
//

import SwiftUI

struct MainScreenView<ViewModel: MainScreenViewModelProtocol>: View {
    
    // MARK: - Private properties
    @ObservedObject private(set) var viewModel: ViewModel
    private let appearance = Appearance()
    private let columns = [
        GridItem(.flexible(minimum: 100, maximum: 250)),
        GridItem(.flexible(minimum: 100, maximum: 250))
    ]
    
    // MARK: - View
    var body: some View {
        NavigationView {
            content.navigationTitle(appearance.title)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            viewModel.fetchDevices()
        })
    }
    
    private var content: some View {
        switch viewModel.state {
        case .loading:
            return AnyView(ProgressView())
        case .error(let _):
            // TO-DO
            return AnyView(ProgressView())
        case .loaded(let devices):
            return AnyView(
                ScrollView {
                    LazyVGrid(columns: columns, content: {
                        ForEach(devices) { device in
                            NavigationLink(
                                destination: RootView(),
                                label: {
                                    DeviceCellView(viewModel: DeviceCellViewModel(device: device))
                                })
                                .buttonStyle(PlainButtonStyle())
                        }
                    })
                }.padding(.horizontal, 10)
            )
        }
    }
}

private extension MainScreenView {
    struct Appearance {
        let title = Localized("MainScreen.Title")
    }
}
