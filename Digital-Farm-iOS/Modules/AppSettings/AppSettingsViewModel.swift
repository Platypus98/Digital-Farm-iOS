//
//  AppSettingsViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 14.04.2022.
//

import Foundation

protocol AppSettingsViewModelProtocol: ObservableObject {
    var state: AppSettingsViewModel.State { get }
    func fetchSettings()
    func saveIPAndPort(ip: String, port: String)
}

final class AppSettingsViewModel: AppSettingsViewModelProtocol {
    // MARK: - Private properties
    @Published private(set) var state = State.loading
    
    // MARK: - Init
    init() { }
    
    // MARK: - AppSettingsViewModelProtocol
    func fetchSettings() {
        state = .loaded(
            AppSettingsVisualModel(
                text: "О приложении \n \(Bundle.main.releaseVersionNumber!), \(Bundle.main.buildVersionNumber!)"
            )
        )
    }
    
    func saveIPAndPort(ip: String, port: String) {
        UserDefaults.standard.set(ip, forKey: "IP")
        UserDefaults.standard.set(Int32(port), forKey: "Port")
    }
}

// MARK: - Extension
extension AppSettingsViewModel {
    enum State {
        case loading
        case loaded(AppSettingsVisualModel)
    }
}
