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
    func fetchData()
    func sendToServer(command: String)
}

final class RemoteControlViewModel: RemoteControlViewModelProtocol {
    @Published private(set) var state = State.loading
    
    let ipAddres: String = UserDefaults.standard.object(forKey: "IP") as? String ?? ""
    let port: Int32 = UserDefaults.standard.object(forKey: "Port") as? Int32 ?? 0
    private let client: SocketClientProtocol
    
    // MARK: - Init
    init(client: SocketClientProtocol = TCPClient.shared) {
        self.client = client
    }
    
    // MARK: - RemoteControlViewModelProtocol
    func fetchData() {
        state = .loaded
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
