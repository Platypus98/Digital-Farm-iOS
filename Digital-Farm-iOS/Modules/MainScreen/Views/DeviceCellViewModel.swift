//
//  DeviceCellViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.01.2022.
//

import Foundation
import SwiftUI

protocol DeviceCellViewModelProtocol: ObservableObject {
    var device: InternetDeviceViewModel { get }
}

final class DeviceCellViewModel: DeviceCellViewModelProtocol {
    
    let device: InternetDeviceViewModel
    
    init(device: InternetDeviceViewModel) {
        self.device = device
    }
}
