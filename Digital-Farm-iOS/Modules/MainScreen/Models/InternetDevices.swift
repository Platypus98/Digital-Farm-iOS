//
//  InternetDevices.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.01.2022.
//

import Foundation
import SwiftUI

enum InternetDeviceStatus {
    case connected
    case notСonnected
    
    var value: String {
        switch self {
        case .connected:
            return "Подключен"
        case .notСonnected:
            return "Не подключен"
        }
    }
}

struct InternetDevice: Identifiable {
    var id: Int
    var name: String
    var status: InternetDeviceStatus
    var image: UIImage
}
