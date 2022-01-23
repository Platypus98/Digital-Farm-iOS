//
//  ComponentsStatusService.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 23.01.2022.
//

import Foundation

protocol ComponentsStatusServiceProtocol {
    func fetchStatuses() -> [FeedPusherComponent]
}

final class ComponentsStatusService: ComponentsStatusServiceProtocol {
    func fetchStatuses() -> [FeedPusherComponent] {
        return [
            .init(name: "Система навигации", status: .ok),
            .init(name: "Система эл. привода", status: .ok),
            .init(name: "Все детали исправны", status: .outOfOrder)
        ]
    }
}
