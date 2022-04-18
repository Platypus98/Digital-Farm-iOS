//
//  ScheduleService.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 02.04.2022.
//

import Foundation

protocol ScheduleServiceProtocol {
    func fetchSchedules() -> [ScheduleTime]
    func addTime(_ time: String)
}

final class ScheduleService: ScheduleServiceProtocol {
    
    private var dataStore: [ScheduleTime] = [
        .init(time: "9:00", isEnabled: true),
        .init(time: "12:00", isEnabled: false),
        .init(time: "15:00", isEnabled: false),
        .init(time: "21:00", isEnabled: true)
    ]
    
    func fetchSchedules() -> [ScheduleTime] {
        return dataStore
    }
    
    func addTime(_ time: String) {
        dataStore.append(.init(time: time, isEnabled: false))
    }
}
