//
//  RemoteControlViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 07.02.2022.
//

import Foundation

import Foundation
import Combine
import SwiftUI
import SwiftSocket

protocol RemoteControlViewModelProtocol: ObservableObject {
    var state: RemoteControlViewModel.State { get }
    func connectToServer()
    func sendToServer(command: String)
}

final class RemoteControlViewModel: RemoteControlViewModelProtocol {
    @Published private(set) var state = State.loading
    
    let ipAddres: String = UserDefaults.standard.object(forKey: "IP") as? String ?? ""
    let port: Int32 = UserDefaults.standard.object(forKey: "Port") as? Int32 ?? 0
    let client: TCPClient
    
    // MARK: - Init
    init() {
        client = TCPClient(address: ipAddres, port: port)
    }

    // MARK: - Debug
    func connectToServer() {
        // DEGUB
        state = .loaded
        DispatchQueue.global().async {
            switch self.client.connect(timeout: 5) {
            case .success:
                DispatchQueue.main.async {
                    self.state = .loaded
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.state = .loaded
                }
            }
        }
    }
    
    func sendToServer(command: String) {
        let data: Data = command.data(using: .utf8) ?? Data()
        switch client.send(data: data) {
        case .success:
            // Успешно
            break
        case .failure(let error):
            DispatchQueue.main.async {
                self.state = .error(error)
            }
        }
    }
}

// MARK: - Extension
extension RemoteControlViewModel {
    enum State {
        case loading
        case loaded
        case error(Error)
    }
}
