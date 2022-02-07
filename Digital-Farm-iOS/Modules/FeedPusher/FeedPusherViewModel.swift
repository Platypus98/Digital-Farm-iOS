//
//  FeedPusherViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 16.01.2022.
//

import Foundation
import SwiftUI

protocol FeedPusherViewModelProtocol: ObservableObject {
    var state: FeedPusherViewModel.State { get }
    var actions: [FeedPusherAction] { get }
    func fetchFeedPusher()
}

final class FeedPusherViewModel: FeedPusherViewModelProtocol {
    
    // MARK: - Private properties
    @Published private(set) var state = State.loading
    private(set) var actions: [FeedPusherAction] = [
        .init(
            id: .schedule,
            title: Localized("FeedPusher.Schedule.Title"),
            iconName: "schedule"
        ),
        .init(
            id: .serviceMenu,
            title: Localized("FeedPusher.ServiceMenu.Title"),
            iconName: "service"
        ),
        .init(
            id: .analytics,
            title: Localized("FeedPusher.Analytics.Title"),
            iconName: "analytics"
        )
    ]
    
    private let feedPusherService: FeedPusherServiceProtocol
    
    // MARK: - Init
    init(
        feedPusherService: FeedPusherServiceProtocol = FeedPusherService()
    ) {
        self.feedPusherService = feedPusherService
    }
    
    // MARK: - FeedPusherViewModelProtocol
    func fetchFeedPusher() {
        let feedPusher = feedPusherService.fetchInfo()
        state = .loaded(
            FeedPusherVisualModel(
                statusText: getStatusText(feedPusher.status),
                statusColor: getStatusColor(feedPusher.status),
                chargeLevel: feedPusher.chargeLevel,
                stockLevel: feedPusher.stockLevel,
                dispenserPerformance: feedPusher.dispenserPerformance
            )
        )
    }
}

// MARK: - Extension
extension FeedPusherViewModel {
    enum State {
        case loading
        case loaded(FeedPusherVisualModel)
        case error(Error)
    }
}

// MARK: - Private methods
private extension FeedPusherViewModel {
    func getStatusColor(_ status: FeedPusherStatus) -> Color {
        switch status {
        case .waiting:
            return Color("waitingStatus")
        case .inWork:
            return Color("inWorkStatus")
        }
    }
    
    func getStatusText(_ status: FeedPusherStatus) -> String {
        switch status {
        case .waiting:
            return Localized("FeedPusher.Status.Waiting")
        case .inWork:
            return Localized("FeedPusher.Status.InWork")
        }
    }
}
