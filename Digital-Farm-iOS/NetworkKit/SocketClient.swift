//
//  SocketClient.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 19.03.2023.
//

import SwiftSocket

protocol SocketClientProtocol {
    func connect(timeout: Int) -> Result
    func close()
    func send(data: [UInt8]) -> Result
    func send(string: String) -> Result
    func send(data: Data) -> Result
    func read(_ expectlen: Int, timeout: Int) -> [UInt8]?
}

extension TCPClient: SocketClientProtocol {
    static let shared = TCPClient(
        address: UserDefaults.standard.object(forKey: "IP") as? String ?? "",
        port: UserDefaults.standard.object(forKey: "Port") as? Int32 ?? 0
    )
}
