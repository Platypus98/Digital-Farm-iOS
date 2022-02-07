//
//  DeviceCellViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.01.2022.
//

import Foundation
import SwiftUI

protocol DeviceCellViewModelProtocol: ObservableObject {
    var device: InternetDeviceVisualModel { get }
}

final class DeviceCellViewModel: DeviceCellViewModelProtocol {
    
    let device: InternetDeviceVisualModel
    
    init(device: InternetDeviceVisualModel) {
        self.device = device
    }
}
