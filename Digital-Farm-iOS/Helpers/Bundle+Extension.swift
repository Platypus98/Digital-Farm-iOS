//
//  Bundle+Extension.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 14.04.2022.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
