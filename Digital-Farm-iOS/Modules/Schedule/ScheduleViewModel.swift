//
//  ScheduleViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 02.04.2022.
//

import Foundation
import SwiftUI
import SwiftSocket

protocol ScheduleViewModelProtocol: ObservableObject {
    var state: ScheduleViewModel.State { get }
    func fetchSchedule()
    func addTime(time: String)
}

final class ScheduleViewModel: ScheduleViewModelProtocol {
    
    // MARK: - Private properties
    @Published private(set) var state = State.loading
    private let scheduleService: ScheduleServiceProtocol
    private let socketClient: SocketClientProtocol
    
    // MARK: - Init
    init(
        scheduleService: ScheduleServiceProtocol = ScheduleService(),
        socketClient: SocketClientProtocol = TCPClient.shared
    ) {
        self.scheduleService = scheduleService
        self.socketClient = socketClient
    }
    
    func fetchSchedule() {
        state = .loading
        scheduleService.fetchSchedules { [weak self] schedule in
            let viewModel = schedule.map {
                ScheduleTimeViewModel(
                    id: UUID(),
                    time: $0.time,
                    isEnabled: $0.isEnabled
                )
            }
            self?.state = .loaded(viewModel)
        }
    }
    
    func addTime(time: String) {
        state = .loading
        scheduleService.addTime(time) { [weak self] in
            self?.fetchSchedule()
        }
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
