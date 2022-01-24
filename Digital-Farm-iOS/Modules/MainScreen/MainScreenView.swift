//
//  MainScreenView.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.01.2022.
//

import SwiftUI

struct MainScreenView<ViewModel: MainScreenViewModelProtocol>: View {
    
    // MARK: - Private properties
    @ObservedObject private var viewModel: ViewModel
    private let appearance = Appearance()
    private let columns = [
        GridItem(.flexible(minimum: 100, maximum: 250)),
        GridItem(.flexible(minimum: 100, maximum: 250))
    ]
    
    // MARK: - Init
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Content
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
        case .error:
            return AnyView(ProgressView())
        case .loaded(let devices):
            return AnyView(
                ScrollView {
                    LazyVGrid(columns: columns, content: {
                        ForEach(devices) { device in
                            NavigationLink(
                                destination: getDestination(device.type),
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

// MARK: - Private methods

private extension MainScreenView {
    func getDestination(_ type: InternetDeviceType) -> some View {
        switch type {
        case .robotFeedPusher:
            return AnyView(FeedPusherView(viewModel: FeedPusherViewModel()))
        case .unknown:
            return AnyView(ProgressView())
        }
    }
}

// MARK: - Appearance
private extension MainScreenView {
    struct Appearance {
        let title = Localized("MainScreen.Title")
    }
}
