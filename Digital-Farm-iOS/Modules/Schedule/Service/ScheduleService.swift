//
//  ScheduleService.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 02.04.2022.
//

import Foundation

protocol ScheduleServiceProtocol {
    func fetchSchedules() -> [ScheduleTime]
}

final class ScheduleService: ScheduleServiceProtocol {
    func fetchSchedules() -> [ScheduleTime] {
        return [
            .init(time: "9:00", isEnabled: true),
            .init(time: "12:00", isEnabled: false),
            .init(time: "15:00", isEnabled: false),
            .init(time: "21:00", isEnabled: true)
        ]
    }
}
