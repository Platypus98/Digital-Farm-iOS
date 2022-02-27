//
//  AnalyticsService.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.02.2022.
//

import Foundation

protocol AnalyticsServiceProtocol {
    func fetchAnalytics() -> Analytics
}

final class AnalyticsService: AnalyticsServiceProtocol {
    func fetchAnalytics() -> Analytics {
        return Analytics(
            cyclesPerDay: 4,
            feedIssued: 30,
            energyValue: .init(
                proteins: 29,
                fats: 38,
                cellulose: 30,
                carbohydrates: 41
            )
        )
    }
}

