//
//  AnalyticsView.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.02.2022.
//

import SwiftUI

struct AnalyticsView<ViewModel: AnalyticsViewModelProtocol>: View {
    
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
            viewModel.fetchAnalyticsInfo()
        })
    }
    
    private var content: some View {
        switch viewModel.state {
        case .loading:
            return AnyView(ProgressView())
        case .error:
            return AnyView(ProgressView())
        case .loaded(let analytics):
            return AnyView(
                VStack(alignment: .leading) {
                    createGeneralInfoView(
                        title: appearance.cyclesPerDayTitle,
                        subtitle: analytics.cyclesPerDay
                    )
                    createGeneralInfoView(
                        title: appearance.feedIssuedTitle,
                        subtitle: analytics.feedIssued
                    )
                    VStack(alignment: .leading, spacing: 15) {
                        Text(appearance.energyValueTitle)
                            .font(.system(size: 18, weight: .medium, design: .default))
                        HStack {
                            createEnergyValueRow(title: appearance.proteinsTitle, subtitle: analytics.proteins)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            createEnergyValueRow(title: appearance.celluloseTitle, subtitle: analytics.cellulose)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        HStack {
                            createEnergyValueRow(title: appearance.fatsTitle, subtitle: analytics.fats)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            createEnergyValueRow(title: appearance.carbohydratesTitle, subtitle: analytics.carbohydrates)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.horizontal, 13)
                    Spacer()
                }
            )
        }
    }
}

extension AnalyticsView {
    func createGeneralInfoView(
        title: String,
        subtitle: String
    ) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                Spacer()
                Text(subtitle)
            }
            Divider()
        }.padding(13)
    }
    
    func createEnergyValueRow(
        title: String,
        subtitle: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .foregroundColor(.gray)
            Text(subtitle)
        }
    }
}

// MARK: - Appearance
private extension AnalyticsView {
    struct Appearance {
        let title = Localized("FeedPusher.Analytics.Title")
        let cyclesPerDayTitle = Localized("FeedPusher.Analytics.CyclesPerDay.Title")
        let feedIssuedTitle = Localized("FeedPusher.Analytics.FeedIssued.Title")
        let energyValueTitle = Localized("FeedPusher.Analytics.EnergyValue.Title")
        
        let proteinsTitle = Localized("FeedPusher.Analytics.Proteins.Title")
        let celluloseTitle = Localized("FeedPusher.Analytics.Cellulose.Title")
        let fatsTitle = Localized("FeedPusher.Analytics.Fats.Title")
        let carbohydratesTitle = Localized("FeedPusher.Analytics.Carbohydrates.Title")
    }
}
