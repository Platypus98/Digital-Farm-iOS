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
    func fetchChangeAvailability(timeID: String, value: Bool, _ completion: @escaping (Swift.Result<Void, Error>)->())
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
            switch self.socketClient.send(string: "#\(timeID):\(time):") {
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
            switch self.socketClient.send(string: "#\(timeID):0000:") {
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
    
    func fetchChangeAvailability(timeID: String, value: Bool, _ completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            let updatedStatuses = self.updateStatuses(timeID: timeID, value: value)
            let result: Swift.Result<Void, Error>
            switch self.socketClient.send(string: "#M50:\(updatedStatuses):") {
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

// MARK: - Private
private extension ScheduleService {
    func updateStatuses(timeID: String, value: Bool) -> String {
        // TODO: - Отрефакторить, вынести в воркер
        var currentAllStatuses = self.dataStore.split(separator: ">")[0].split(separator: ":")[1].map({ String($0) })
        let updatedRow = Int(timeID.suffix(1)) ?? 0
        let updatedIndex: Int
        let updatedLocalRow: Int = updatedRow % 3 == 0 ? 3 : updatedRow % 3
        var availableRows: [Int] = []
        if updatedRow >= 7 {
            updatedIndex = 2
        } else if updatedRow >= 4 {
            updatedIndex = 1
        } else {
            updatedIndex = 0
        }
        switch Int(currentAllStatuses[updatedIndex]) {
        case 0:
            break
        case 1:
            availableRows.append(1)
        case 2:
            availableRows.append(2)
        case 3:
            availableRows.append(1)
            availableRows.append(2)
        case 4:
            availableRows.append(3)
        case 5:
            availableRows.append(1)
            availableRows.append(3)
        case 6:
            availableRows.append(2)
            availableRows.append(3)
        case 7:
            availableRows.append(1)
            availableRows.append(2)
            availableRows.append(3)
        default:
            break
        }
        
        if value {
            availableRows.append(updatedLocalRow)
        } else {
            availableRows = availableRows.filter( { $0 != updatedLocalRow } )
        }
        
        let newStatusValue: String
        switch availableRows {
        case [1]:
            newStatusValue = "1"
        case [2]:
            newStatusValue = "2"
        case [1, 2]:
            newStatusValue = "3"
        case [3]:
            newStatusValue = "4"
        case [1, 3]:
            newStatusValue = "5"
        case [2, 3]:
            newStatusValue = "6"
        case [1, 2, 3]:
            newStatusValue = "7"
        default:
            newStatusValue = "7"
        }
        currentAllStatuses[updatedIndex] = newStatusValue
        return currentAllStatuses.joined()
    }
}
