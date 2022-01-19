//
//  FeedPusherAction.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 19.01.2022.
//

import Foundation
import SwiftUI

enum ActionType {
    case schedule
    case serviceMenu
    case analytics
}

struct FeedPusherAction: Identifiable {
    let id: ActionType
    let title: String
    let iconName: String
}
