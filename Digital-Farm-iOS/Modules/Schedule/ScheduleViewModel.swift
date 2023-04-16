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
    func deleteTime(timeID: String)
    func changeAvailability(timeID: String, newValue: Bool)
}

final class ScheduleViewModel: ScheduleViewModelProtocol {
    
    // MARK: - Private properties
    @Published private(set) var state = State.loading
    private let scheduleService: ScheduleServiceProtocol
    private let scheduleViewModelBuilder: ScheduleViewModelBuilderProtocol
    
    // MARK: - Init
    init(
        scheduleService: ScheduleServiceProtocol = ScheduleService(),
        scheduleViewModelBuilder: ScheduleViewModelBuilderProtocol = ScheduleViewModelBuilder()
    ) {
        self.scheduleService = scheduleService
        self.scheduleViewModelBuilder = scheduleViewModelBuilder
    }
    
    func fetchSchedule() {
        state = .loading
        scheduleService.fetchSchedules { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let rawData):
                let viewModels = self.scheduleViewModelBuilder.createViewModels(from: rawData)
                self.state = .loaded(viewModels)
            case .failure(let error):
                self.state = .error(error)
            }
        }
    }
    
    func addTime(time: String) {
        guard case let .loaded(currentViewModels) = state,
              let lastScheduleNumber = currentViewModels.last?.id.suffix(2),
              let lastScheduleNumberInt = Int(lastScheduleNumber) else { return }
        let newTimeID = "\(lastScheduleNumberInt + 1)"
        state = .loading
        scheduleService.fetchAddTime(timeID: newTimeID, time: time) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.fetchSchedule()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.state = .error(error)
                }
            }
        }
    }
    
    func deleteTime(timeID: String) {
        state = .loading
        scheduleService.fetchDeleteTime(timeID: timeID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.fetchSchedule()
            case .failure(let error):
                self.state = .error(error)
            }
        }
    }
    
    func changeAvailability(timeID: String, newValue: Bool) { }
}

// MARK: - Extension
extension ScheduleViewModel {
    enum State {
        case loading
        case loaded([ScheduleTimeViewModel])
        case error(Error)
    }
}
