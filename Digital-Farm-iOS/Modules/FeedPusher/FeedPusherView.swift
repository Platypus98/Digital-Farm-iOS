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
                ScrollView {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(feedPusher.status.textValue)
                                .font(.system(size: 25, weight: .medium, design: .default))
                                .foregroundColor(statusColor(feedPusher.status))
                            
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
                                        destination: RootView(),
                                        label: {
                                            ActionView(title: action.title, iconName: action.iconName)
                                        }
                                    )
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.all, 13)
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
    }
    
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
        let dispenserPerformance = Localized("FeedPusher.DispenserPerformance.Title")
        let waitingColor = Color("waitingStatus")
        let inWorkColor = Color("inWorkStatus")
    }
}
