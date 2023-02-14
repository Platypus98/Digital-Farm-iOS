//
//  String+Extension.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 13.08.2022.
//

import Foundation

extension String {
    /// Преобразовывает строку в строку для команду, добавляя в начале указанный символ
    /// - Parameters:
    ///   - maxDigits: Макисмальное число символов в строке
    ///   - symbol: Символ, который нужно добавить
    func convertToComand(maxDigits: Int = 4, with symbol: String = "0") -> String {
        let command: String
        if self.count >= maxDigits {
            command = String(self.prefix(maxDigits))
        } else {
            command = String(repeating: symbol, count: maxDigits - self.count) + self
        }
        
        return command
    }
}
