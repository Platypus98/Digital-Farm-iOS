//
//  Analytics.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.02.2022.
//

import Foundation

struct Analytics {
    let cyclesPerDay: Int
    let feedIssued: Int
    let energyValue: EnergyValue
}

struct EnergyValue {
    let proteins: Int
    let fats: Int
    let cellulose: Int
    let carbohydrates: Int
}
