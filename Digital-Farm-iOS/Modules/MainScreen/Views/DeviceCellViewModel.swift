//
//  DeviceCellViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.01.2022.
//

import Foundation
import SwiftUI

protocol DeviceCellViewModelProtocol: ObservableObject {
    var device: InternetDevice { get }
}

final class DeviceCellViewModel: DeviceCellViewModelProtocol {
    
    let device: InternetDevice
    
    init(device: InternetDevice) {
        self.device = device
    }
}
