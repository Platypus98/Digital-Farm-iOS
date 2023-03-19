//
//  ScheduleViewModelBuilder.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 19.03.2023.
//

import Foundation

protocol ScheduleViewModelBuilderProtocol {
    func createViewModels(from rawData: String) -> [ScheduleTimeViewModel]
}

final class ScheduleViewModelBuilder: ScheduleViewModelBuilderProtocol {
    
    init() {}
    
    func createViewModels(from rawData: String) -> [ScheduleTimeViewModel] {
        let rawCommands = rawData.split(separator: ">")
        let scheduleRawItems = rawCommands[1...]
        guard !scheduleRawItems.isEmpty else { return [] }
        
        let enabledSchedulesTimes: [Int] = mapEnabledStatus(statuses: String(rawCommands[0]))
        var result: [ScheduleTimeViewModel] = []
        for (index, item) in scheduleRawItems.enumerated() {
            let itemComponents = item.split(separator: ":")
            guard itemComponents[1] != "0000" else { continue }
            let hours = itemComponents[1].prefix(2)
            let minutes = itemComponents[1].suffix(2)
            result.append(
                ScheduleTimeViewModel(
                    id: String(itemComponents[0]),
                    time: "\(hours):\(minutes)",
                    isEnabled: enabledSchedulesTimes.contains(index + 1)
                )
            )
        }
        
        return result
    }
    
    private func mapEnabledStatus(statuses: String) -> [Int] {
        let rawStatuses: [String] = statuses.components(separatedBy: ":")[1].map({ String($0) })
        var result: [Int] = []
        for (index, item) in rawStatuses.enumerated() {
            let coefficient = index * 3
            switch Int(item) {
            case 0:
                continue
            case 1:
                result.append(1 + coefficient)
            case 2:
                result.append(2 + coefficient)
            case 3:
                result.append(1 + coefficient)
                result.append(2 + coefficient)
            case 4:
                result.append(3 + coefficient)
            case 5:
                result.append(1 + coefficient)
                result.append(3 + coefficient)
            case 6:
                result.append(2 + coefficient)
                result.append(3 + coefficient)
            case 7:
                result.append(1 + coefficient)
                result.append(2 + coefficient)
                result.append(3 + coefficient)
            default:
                continue
            }
        }
        return result
    }
}
