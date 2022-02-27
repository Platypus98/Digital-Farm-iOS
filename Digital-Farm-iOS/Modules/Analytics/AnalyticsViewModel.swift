//
//  AnalyticsViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.02.2022.
//

import Foundation

protocol AnalyticsViewModelProtocol: ObservableObject {
    var state: AnalyticsViewModel.State { get }
    func fetchAnalyticsInfo()
}

final class AnalyticsViewModel: AnalyticsViewModelProtocol {
    // MARK: - Private properties
    @Published private(set) var state = State.loading
    
    private let analyticsService: AnalyticsServiceProtocol
    
    // MARK: - Init
    init(
        analyticsService: AnalyticsServiceProtocol = AnalyticsService()
    ) {
        self.analyticsService = analyticsService
    }
    
    // MARK: - FeedPusherViewModelProtocol
    func fetchAnalyticsInfo() {
        let analytics = analyticsService.fetchAnalytics()
        state = .loaded(
            AnalyticsVisualModel(
                cyclesPerDay: String(analytics.cyclesPerDay),
                feedIssued: String(analytics.feedIssued),
                proteins: percent(analytics.energyValue.proteins),
                fats: percent(analytics.energyValue.fats),
                cellulose: percent(analytics.energyValue.cellulose),
                carbohydrates: percent(analytics.energyValue.carbohydrates)
            )
        )
    }
}

// MARK: - State
extension AnalyticsViewModel {
    enum State {
        case loading
        case loaded(AnalyticsVisualModel)
        case error(Error)
    }
}


// MARK: - Private extension
private extension AnalyticsViewModel {
    func percent(_ value: Int) -> String {
        return "\(value) %"
    }
}
