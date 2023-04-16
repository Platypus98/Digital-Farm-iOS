//
//  ScheduleService.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 02.04.2022.
//

import Foundation
import SwiftSocket

protocol ScheduleServiceProtocol {
    func fetchSchedules(_ completion: @escaping (Swift.Result<String, Error>)->())
    func fetchAddTime(timeID: String, time: String, _ completion: @escaping (Swift.Result<Void, Error>)->())
    func fetchDeleteTime(timeID: String, _ completion: @escaping (Swift.Result<Void, Error>)->())
}

final class ScheduleService: ScheduleServiceProtocol {
    private let socketClient: SocketClientProtocol
    private var dataStore: String = ""
    
    init(socketClient: SocketClientProtocol = TCPClient.shared) {
        self.socketClient = socketClient
    }
    
    func fetchSchedules(_ completion: @escaping (Swift.Result<String, Error>)->() = { _ in }) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let result: Swift.Result<String, Error>
            self.socketClient.cleanResponseStack()
            switch self.socketClient.send(string: "#M50:0001:") {
            case .success:
                let bytes = self.socketClient.read(110, timeout: 5)
                if let bytes = bytes {
                    let rawData = String(decoding: Data(bytes), as: UTF8.self)
                    self.dataStore = rawData
                    result = .success(rawData)
                }
                else {
                    result = .failure(DefaultError.networkError)
                }
            case .failure(let error):
                result = .failure(error)
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func fetchAddTime(timeID: String, time: String, _ completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let result: Swift.Result<Void, Error>
            switch self.socketClient.send(string: "#M\(timeID):\(time):") {
            case .success:
                let bytes = self.socketClient.read(10, timeout: 5)
                if let _ = bytes {
                    result = .success(())
                } else {
                    result = .failure(DefaultError.networkError)
                }
            case .failure(let error):
                result = .failure(error)
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func fetchDeleteTime(timeID: String, _ completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let result: Swift.Result<Void, Error>
            switch self.socketClient.send(string: "#M50\(timeID):0000:") {
            case .success:
                let bytes = self.socketClient.read(10, timeout: 5)
                if let _ = bytes {
                    result = .success(())
                } else {
                    result = .failure(DefaultError.networkError)
                }
            case .failure(let error):
                result = .failure(error)
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
