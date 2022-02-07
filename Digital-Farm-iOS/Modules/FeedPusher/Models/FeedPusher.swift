//
//  FeedPusher.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 16.01.2022.
//

import Foundation

struct FeedPusher {
    var status: FeedPusherStatus
    var chargeLevel: Double
    var stockLevel: Double
    var dispenserPerformance: Int
}

enum FeedPusherStatus {
    case waiting
    case inWork
}
