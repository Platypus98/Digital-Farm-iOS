//
//  ScheduleViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 02.04.2022.
//

import Foundation
import SwiftUI

protocol ScheduleViewModelProtocol: ObservableObject {
    var state: ScheduleViewModel.State { get }
    func fetchSchedule()
}

final class ScheduleViewModel: ScheduleViewModelProtocol {
    
    // MARK: - Private properties
    @Published private(set) var state = State.loading
    private let scheduleService: ScheduleServiceProtocol
    
    // MARK: - Init
    init(
        scheduleService: ScheduleServiceProtocol = ScheduleService()
    ) {
        self.scheduleService = scheduleService
    }
    
    func fetchSchedule() {
        let components = scheduleService.fetchSchedules()
        
        let viewModel = components.map {
            ScheduleTimeViewModel(
                id: UUID(),
                time: $0.time,
                isEnabled: $0.isEnabled
            )
        }
        state = .loaded(viewModel)
    }
}

// MARK: - Extension
extension ScheduleViewModel {
    enum State {
        case loading
        case loaded([ScheduleTimeViewModel])
        case error(Error)
    }
}
