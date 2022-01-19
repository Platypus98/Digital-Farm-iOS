//
//  ActionView.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 19.01.2022.
//

import SwiftUI

struct ActionView: View {
    
    // MARK: - Private properties
    private(set) var title: String
    private(set) var iconName: String
    
    
    // MARK: - Lifecycle
    var body: some View {
        HStack {
            Image(iconName)
                .padding(.all, 13)
            Spacer(minLength: 13)
            VStack(alignment: .leading) {
                Spacer(minLength: 13)
                HStack {
                    Text(title)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                }
                Spacer(minLength: 20)
                Divider()
            }
        }
    }
}
