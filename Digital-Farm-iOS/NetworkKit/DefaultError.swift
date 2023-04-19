//
//  DefaultError.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 01.04.2023.
//

import Foundation

enum DefaultError: Error {
    case networkError
}

extension DefaultError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError:
            return Localized("DefaultErrors.NetworkError")
        }
    }
}
