//
//  FeedPusherViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 16.01.2022.
//

import Foundation

protocol FeedPusherViewModelProtocol: ObservableObject {
    var state: FeedPusherViewModel.State { get }
    func fetchFeedPusher()
}

final class FeedPusherViewModel: FeedPusherViewModelProtocol {
    
    // MARK: - Private properties
    @Published private(set) var state = State.loading
    
    private let feedPusherService: FeedPusherServiceProtocol
    
    // MARK: - Init
    init(feedPusherService: FeedPusherServiceProtocol) {
        self.feedPusherService = feedPusherService
    }
    
    func fetchFeedPusher() {
        state = .loaded(feedPusherService.fetchInfo())
    }
}

// MARK: - Extension
extension FeedPusherViewModel {
    enum State {
        case loading
        case loaded(FeedPusher)
        case error(Error)
    }
}
