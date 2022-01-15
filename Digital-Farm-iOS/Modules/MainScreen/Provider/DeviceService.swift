//
//  DeviceService.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.01.2022.
//

import Foundation
import SwiftUI

protocol DeviceServiceProtocol {
    func fetchDevices() -> [InternetDevice]
}

final class DeviceService: DeviceServiceProtocol {
    func fetchDevices() -> [InternetDevice] {
        return [
            .init(id: 1,
                  name: "Робот feed pusher",
                  status: .connected,
                  image: UIImage(named: "robot-feed-pusher") ?? UIImage()
            ),
            .init(id: 2,
                  name: "Робот dairy",
                  status: .notСonnected,
                  image: UIImage(named: "cow") ?? UIImage()
            ),
            .init(id: 3,
                  name: "Система microclimate",
                  status: .notСonnected,
                  image: UIImage(named: "weather") ?? UIImage()
            ),
        ]
    }
}
