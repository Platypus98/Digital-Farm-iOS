//
//  FeedPusherComponent.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 23.01.2022.
//

import Foundation

struct FeedPusherComponent {
    let name: String
    let status: ComponentStatus
}

enum ComponentStatus {
    case ok
    case outOfOrder
}
