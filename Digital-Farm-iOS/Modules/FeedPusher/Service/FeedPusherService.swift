//
//  FeedPusherService.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 16.01.2022.
//

import Foundation

protocol FeedPusherServiceProtocol {
    func fetchInfo() -> FeedPusher
}

final class FeedPusherService: FeedPusherServiceProtocol {
    func fetchInfo() -> FeedPusher {
        return FeedPusher(
            status: .waiting,
            chargeLevel: 50,
            stockLevel: 30,
            dispenserPerformance: 50
        )
    }
}
