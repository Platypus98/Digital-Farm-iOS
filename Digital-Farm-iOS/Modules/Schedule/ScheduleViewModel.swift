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
    private let scheduleViewModelBuilder: ScheduleViewModelBuilderProtocol
    
    // MARK: - Init
    init(
        scheduleService: ScheduleServiceProtocol = ScheduleService(),
        socketClient: SocketClientProtocol = TCPClient.shared,
        scheduleViewModelBuilder: ScheduleViewModelBuilderProtocol = ScheduleViewModelBuilder()
    ) {
        self.scheduleService = scheduleService
        self.socketClient = socketClient
        self.scheduleViewModelBuilder = scheduleViewModelBuilder
    }
    
    func fetchSchedule() {
        state = .loading
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            switch self.socketClient.send(string: "#M50:0001:") {
            case .success:
                let bytes = self.socketClient.read(100, timeout: 5)
                let rawData = String(decoding: Data(bytes!), as: UTF8.self)
                let viewModels = self.scheduleViewModelBuilder.createViewModels(from: rawData)
                DispatchQueue.main.async {
                    self.state = .loaded(viewModels)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.state = .error(error)
                }
            }
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
