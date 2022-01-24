//
//  InternetDevice.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.01.2022.
//

import Foundation
import SwiftUI

struct InternetDevice {
    var type: InternetDeviceType
    var name: String
    var status: InternetDeviceStatus
    var image: UIImage
}

enum InternetDeviceStatus {
    case connected
    case notСonnected
}

enum InternetDeviceType {
    case robotFeedPusher
    case unknown
}
