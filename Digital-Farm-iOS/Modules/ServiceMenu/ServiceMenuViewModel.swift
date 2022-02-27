//
//  ServiceMenuViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 23.01.2022.
//

import Foundation
import SwiftUI

protocol ServiceMenuViewModelProtocol: ObservableObject {
    var state: ServiceMenuViewModel.State { get }
    func fetchComponentsStatus()
}

final class ServiceMenuViewModel: ServiceMenuViewModelProtocol {
    
    // MARK: - Private properties
    @Published private(set) var state = State.loading
    private let componentsStatusService: ComponentsStatusServiceProtocol
    
    // MARK: - Init
    init(
        componentsStatusService: ComponentsStatusServiceProtocol = ComponentsStatusService()
    ) {
        self.componentsStatusService = componentsStatusService
    }
    
    // MARK: ServiceMenuViewModelProtocol
    func fetchComponentsStatus() {
        let components = componentsStatusService.fetchStatuses()
        state = .loaded(components.map {
            FeedPusherComponentVisualModel(
                id: .init(),
                name: $0.name,
                statusColor: statusColor($0.status)
            )
        })
    }
}

// MARK: - Extension
extension ServiceMenuViewModel {
    enum State {
        case loading
        case loaded([FeedPusherComponentVisualModel])
        case error(Error)
    }
}

// MARK: - Private methods
private extension ServiceMenuViewModel {
    func statusColor(_ status: ComponentStatus) -> Color {
        switch status {
        case .ok:
            return .green
        case .outOfOrder:
            return .red
        }
    }
}
