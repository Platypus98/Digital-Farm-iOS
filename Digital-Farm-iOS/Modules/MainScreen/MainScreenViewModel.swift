//
//  MainScreenViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.01.2022.
//

import Foundation
import Combine

protocol MainScreenViewModelProtocol: ObservableObject {
    var state: MainScreenViewModel.State { get }
    func fetchDevices()
}

final class MainScreenViewModel: MainScreenViewModelProtocol {
    
    // MARK: - Private properties
    @Published private(set) var state = State.loading
    private var bag = Set<AnyCancellable>()
    
    private let devicesService: DeviceServiceProtocol
    
    // MARK: - Init
    init(
        devicesService: DeviceServiceProtocol = DeviceService()
    ) {
        self.devicesService = devicesService
    }
    
    // MARK: - MainScreenViewModelProtocol
    func fetchDevices() {
        state = .loaded(devicesService.fetchDevices())
    }
}

// MARK: - Extension
extension MainScreenViewModel {
    enum State {
        case loading
        case loaded([InternetDevice])
        case error(Error)
    }
}
