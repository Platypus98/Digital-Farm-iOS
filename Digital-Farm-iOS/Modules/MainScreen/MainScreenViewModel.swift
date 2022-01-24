//
//  MainScreenViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.01.2022.
//

import Foundation
import Combine
import SwiftUI

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
        let internetDevices = devicesService.fetchDevices()
        state = .loaded(internetDevices.map {
            InternetDeviceViewModel(
                id: .init(),
                type: $0.type,
                name: $0.name,
                statusText: getStatusText($0.status),
                statusColor: getStatusColor($0.status),
                image: $0.image
            )
        })
    }
}

// MARK: - Extension
extension MainScreenViewModel {
    enum State {
        case loading
        case loaded([InternetDeviceViewModel])
        case error(Error)
    }
}

// MARK: - Private methods
private extension MainScreenViewModel {
    func getStatusText(_ status: InternetDeviceStatus) -> String {
        switch status {
        case .connected:
            return Localized("MainScreen.InternetDevice.Connected")
        case .notСonnected:
            return Localized("MainScreen.InternetDevice.NotСonnected")
        }
    }
    
    func getStatusColor(_ status: InternetDeviceStatus) -> Color {
        switch status {
        case .connected:
            return Color("availableStatus")
        case .notСonnected:
            return Color("notAvailableStatus")
        }
    }
}
