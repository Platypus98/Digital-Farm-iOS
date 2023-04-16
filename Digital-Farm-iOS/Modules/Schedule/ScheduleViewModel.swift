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
    func deleteTime(timeId: String)
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
            self.socketClient.cleanResponseStack()
            switch self.socketClient.send(string: "#M50:0001:") {
            case .success:
                let bytes = self.socketClient.read(110, timeout: 5)
                guard let bytes = bytes else {
                    DispatchQueue.main.async {
                        self.state = .error(DefaultError.networkError)
                    }
                    return
                }
                let rawData = String(decoding: Data(bytes), as: UTF8.self)
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
        guard case let .loaded(currentViewModels) = state,
              let lastScheduleNumber = currentViewModels.last?.id.suffix(2),
              let lastScheduleNumberInt = Int(lastScheduleNumber)  else { return }
        let newCommandCell = "\(lastScheduleNumberInt + 1)"
        let fullRequest = "#M\(newCommandCell):\(time):"
        state = .loading
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            switch self.socketClient.send(string: fullRequest) {
            case .success:
                let bytes = self.socketClient.read(10, timeout: 5)
                DispatchQueue.main.async {
                    guard let _ = bytes else { self.state = .error(DefaultError.networkError); return }
                    self.fetchSchedule()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.state = .error(error)
                }
            }
        }
    }
    
    func deleteTime(timeId: String) {
        state = .loading
        let fullRequest = "#\(timeId):0000:"
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            switch self.socketClient.send(string: fullRequest) {
            case .success:
                let bytes = self.socketClient.read(10, timeout: 5)
                DispatchQueue.main.async {
                    guard let _ = bytes else { self.state = .error(DefaultError.networkError); return }
                    self.fetchSchedule()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.state = .error(error)
                }
            }
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
