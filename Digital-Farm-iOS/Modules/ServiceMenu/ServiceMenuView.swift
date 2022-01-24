//
//  ServiceMenuView.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 23.01.2022.
//

import SwiftUI

struct ServiceMenuView<ViewModel: ServiceMenuViewModelProtocol>: View {
    
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
            viewModel.fetchComponentsStatus()
        })
    }
    
    private var content: some View {
        switch viewModel.state {
        case .loading:
            return AnyView(ProgressView())
        case .error:
            return AnyView(ProgressView())
        case .loaded(let componentsStatus):
            return AnyView(
                VStack(alignment: .leading){
                    ForEach(componentsStatus) { component in
                        VStack {
                            HStack {
                                Text(component.name)
                                Spacer()
                                Circle()
                                    .fill(component.statusColor)
                                    .frame(width: 16, height: 16)
                            }
                            .padding(.bottom, 10)
                            Divider()
                        }
                        .padding(.trailing, 10)
                    }
                    Spacer()
                }
                    .padding(13)
            )
        }
    }
}

// MARK: - Appearance

private extension ServiceMenuView {
    struct Appearance {
        let title = Localized("FeedPusher.ServiceMenu.Title")
    }
}
