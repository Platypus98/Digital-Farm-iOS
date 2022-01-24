//
//  InternetDeviceViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 24.01.2022.
//

import Foundation
import SwiftUI

struct InternetDeviceViewModel: Identifiable {
    var id: UUID
    var type: InternetDeviceType
    var name: String
    var statusText: String
    var statusColor: Color
    var image: UIImage
}
