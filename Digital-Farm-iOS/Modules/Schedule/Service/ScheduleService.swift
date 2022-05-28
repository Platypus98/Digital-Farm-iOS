//
//  ScheduleService.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 02.04.2022.
//

import Foundation

protocol ScheduleServiceProtocol {
    func fetchSchedules(_ completion: @escaping ([ScheduleTime])->())
    func addTime(_ time: String, _ completion: @escaping ()->())
}

final class ScheduleService: ScheduleServiceProtocol {
    
    private var dataStore: [ScheduleTime] = [
        .init(time: "9:00", isEnabled: true),
        .init(time: "12:00", isEnabled: false),
        .init(time: "15:00", isEnabled: false),
        .init(time: "21:00", isEnabled: true)
    ]
    
    func fetchSchedules(_ completion: @escaping ([ScheduleTime])->() = { _ in }) {
        completion(dataStore)
    }
    
    func addTime(_ time: String, _ completion: @escaping ()->() = { }) {
        dataStore.append(.init(time: time, isEnabled: false))
        completion()
    }
}
