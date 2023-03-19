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
    @State private var dispenserPerformance = 30.0
    private let appearance = Appearance()
    
    // MARK: - Init
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Content
    var body: some View {
        content.navigationTitle(appearance.title)
        .onLoad {
            viewModel.fetchFeedPusher()
        }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .loading:
            return AnyView(ProgressView())
        case .error(let error):
            return AnyView(
                Text(error.localizedDescription)
            )
        case .loaded(let feedPusher):
            return AnyView(
                VStack {
                    ScrollView {
                            VStack(alignment: .leading) {
                                Text(feedPusher.statusText)
                                    .font(.system(size: 25, weight: .medium, design: .default))
                                    .foregroundColor(feedPusher.statusColor)
                                
                                Spacer(minLength: 20)
                                Group {
                                    HStack {
                                        createProgressView(title: appearance.chargeTitle, percent: feedPusher.chargeLevel)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        createProgressView(title: appearance.stockLevelTitle, percent: feedPusher.stockLevel)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                
                                Spacer(minLength: 30)
                                Group {
                                    Text(appearance.dispenserPerformance)
                                    VStack {
                                        createSliderView(initValue: $dispenserPerformance)
                                        Text("\(Int(dispenserPerformance))")
                                            .padding(.all, 10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.gray, lineWidth: 1)
                                            )
                                    }
                                }
                                
                                Spacer(minLength: 30)
                                VStack(alignment: .leading){
                                    ForEach(viewModel.actions) { action in
                                        NavigationLink(
                                            destination: destinationView(actionType: action.id),
                                            label: {
                                                ActionView(title: action.title, iconName: action.iconName)
                                            }
                                        )
                                    }
                                }
                            }
                        .padding(.all, 13)
                    }
                }
            )
        }
    }
}

// MARK: - Private extension
private extension FeedPusherView {
    
    private func createProgressView(
        title: String,
        percent: Double
    ) -> some View {
        InterestStateView(
            viewModel: InterestStateViewModel(
                progress: .init(
                    title: title,
                    percent: percent
                )
            )
        )
    }
    
    private func createSliderView(initValue: Binding<Double>) -> some View {
        Slider(
            value: initValue,
            in: 0...100,
            step: 1,
            onEditingChanged: { _ in },
            minimumValueLabel: Text("0"),
            maximumValueLabel: Text("100")
        ) {
            Text(appearance.dispenserPerformance)
        }
        .tint(.gray)
    }

    private func destinationView(actionType: ActionType) -> some View {
        switch actionType {
        case .schedule:
            return AnyView(ScheduleView(viewModel: ScheduleViewModel()))
        case .serviceMenu:
            return AnyView(ServiceMenuView(viewModel: ServiceMenuViewModel()))
        case .analytics:
            return AnyView(AnalyticsView(viewModel: AnalyticsViewModel()))
        case .remoteControl:
            return AnyView(RemoteControlView(viewModel: RemoteControlViewModel()))
        }
    }
}

// MARK: - Appearance

private extension FeedPusherView {
    struct Appearance {
        let title = Localized("FeedPusher.Title")
        let chargeTitle = Localized("FeedPusher.Charge.Title")
        let stockLevelTitle = Localized("FeedPusher.StockLevel.Title")
        let dispenserPerformance = Localized("FeedPusher.DispenserPerformance.Title")
    }
}
