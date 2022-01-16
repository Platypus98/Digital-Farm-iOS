//
//  FeedPusherView.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 16.01.2022.
//

import SwiftUI

struct FeedPusherView<ViewModel: FeedPusherViewModelProtocol>: View {
    
    // MARK: - Private properties
    @ObservedObject private var viewModel: ViewModel
    private let appearance = Appearance()
    
    // MARK: - Init
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content.navigationTitle(appearance.title)
        .onAppear(perform: {
            viewModel.fetchFeedPusher()
        })
    }
    
    private var content: some View {
        switch viewModel.state {
        case .loading:
            return AnyView(ProgressView())
        case .error:
            return AnyView(ProgressView())
        case .loaded(let feedPusher):
            return AnyView(
                HStack {
                    VStack(alignment: .leading) {
                        Text(feedPusher.status.textValue)
                            .font(.system(size: 25, weight: .medium, design: .default))
                            .foregroundColor(statusColor(feedPusher.status))
                        HStack {
                            InterestStateView(
                                viewModel: InterestStateViewModel(
                                    progress: .init(
                                        title: appearance.chargeTitle,
                                        percent: feedPusher.chargeLevel
                                    )
                                )
                            )
                            InterestStateView(
                                viewModel: InterestStateViewModel(
                                    progress: .init(
                                        title: appearance.stockLevelTitle,
                                        percent: feedPusher.stockLevel
                                    )
                                )
                            )
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.all, 13)
            )
        }
    }
}

// MARK: - Private extension
private extension FeedPusherView {
    
    private func statusColor(_ status: FeedPusherStatus) -> Color {
        switch status {
        case .waiting:
            return appearance.waitingColor
        case .inWork:
            return appearance.inWorkColor
        }
    }
}

// MARK: - Appearance

private extension FeedPusherView {
    struct Appearance {
        let title = Localized("FeedPusher.Title")
        let chargeTitle = Localized("FeedPusher.Charge.Title")
        let stockLevelTitle = Localized("FeedPusher.StockLevel.Title")
        let waitingColor = Color("waitingStatus")
        let inWorkColor = Color("inWorkStatus")
    }
}
