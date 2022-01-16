//
//  ProgressBar.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 16.01.2022.
//

import SwiftUI

struct ProgressBar: View {
    private(set) var value: Double
    private let appearance = Appearance()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(appearance.backgroundColor)
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(appearance.progressColor)
            }.cornerRadius(45.0)
        }
    }
}

// MARK: - Appearance

private extension ProgressBar {
    struct Appearance {
        let backgroundColor = Color("progressBackground")
        let progressColor = Color("progress")
    }
}
