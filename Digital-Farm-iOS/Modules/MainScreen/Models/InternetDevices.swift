//
//  InternetDevices.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.01.2022.
//

import Foundation
import SwiftUI

struct InternetDevice: Identifiable {
    var id: Int
    var name: String
    var status: InternetDeviceStatus
    var image: UIImage
}

enum InternetDeviceStatus {
    case connected
    case notСonnected
    
    var textValue: String {
        switch self {
        case .connected:
            return Localized("MainScreen.InternetDevice.Connected")
        case .notСonnected:
            return Localized("MainScreen.InternetDevice.NotСonnected")
        }
    }
}
