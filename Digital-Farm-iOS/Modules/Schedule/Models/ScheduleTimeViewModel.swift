//
//  ScheduleTimeViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 02.04.2022.
//

import Foundation

struct ScheduleTimeViewModel: Identifiable {
    var id: UUID
    var time: String
    var isEnabled: Bool
}
