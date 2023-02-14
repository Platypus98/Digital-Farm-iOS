//
//  ScalableText.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 17.06.2022.
//

import SwiftUI

struct ScalableText: View {
    
    private let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .scaledToFill()
            .minimumScaleFactor(0.01)
            .lineLimit(1)
    }
}
