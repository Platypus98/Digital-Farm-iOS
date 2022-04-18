//
//  UIApplication+Extension.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 17.04.2022.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
