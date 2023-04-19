//
//  FeedPusherViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 16.01.2022.
//

import Foundation
import SwiftUI
import SwiftSocket

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
        ),
        .init(
            id: .remoteControl,
            title: Localized("FeedPusher.RemoteControl.Title"),
            iconName: "remote-control"
        )
    ]
    
    private let feedPusherService: FeedPusherServiceProtocol
    private let socketClient: SocketClientProtocol
    
    // MARK: - Init
    init(
        feedPusherService: FeedPusherServiceProtocol = FeedPusherService(),
        socketClient: SocketClientProtocol = TCPClient.shared
    ) {
        self.feedPusherService = feedPusherService
        self.socketClient = socketClient
    }
    
    // MARK: - FeedPusherViewModelProtocol
    func fetchFeedPusher() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            switch self.socketClient.connect(timeout: 5) {
            case .success:
                DispatchQueue.main.async {
                    let feedPusher = self.feedPusherService.fetchInfo()
                    self.state = .loaded(
                        FeedPusherVisualModel(
                            statusText: self.getStatusText(feedPusher.status),
                            statusColor: self.getStatusColor(feedPusher.status),
                            chargeLevel: feedPusher.chargeLevel,
                            stockLevel: feedPusher.stockLevel,
                            dispenserPerformance: feedPusher.dispenserPerformance
                        )
                    )
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.state = .error(error)
                }
            }
        }
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
