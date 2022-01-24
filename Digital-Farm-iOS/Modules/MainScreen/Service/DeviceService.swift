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
            .init(type: .robotFeedPusher,
                  name: "Робот feed pusher",
                  status: .connected,
                  image: UIImage(named: "robot-feed-pusher") ?? UIImage()
            ),
            .init(type: .unknown,
                  name: "Робот dairy",
                  status: .notСonnected,
                  image: UIImage(named: "cow") ?? UIImage()
            ),
            .init(type: .unknown,
                  name: "Система microclimate",
                  status: .notСonnected,
                  image: UIImage(named: "weather") ?? UIImage()
            ),
        ]
    }
}
