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
                .renderingMode(.template)
                .tint(.primary)
                .padding(.all, 13)
            Spacer(minLength: 13)
            VStack(alignment: .leading) {
                Spacer(minLength: 13)
                HStack {
                    Text(title)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                Spacer(minLength: 20)
                Divider()
            }
        }
    }
}
