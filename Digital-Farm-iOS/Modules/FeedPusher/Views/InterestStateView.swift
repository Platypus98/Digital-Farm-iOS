//
//  InterestStateView.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 16.01.2022.
//

import SwiftUI

struct InterestStateView<ViewModel: InterestStateViewModelProtocol>: View {
    
    // MARK: - Private properties
    @ObservedObject private(set) var viewModel: ViewModel
    private let appearance = Appearance()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.progress.title)
                    .foregroundColor(appearance.titleColor)
                Text(String(Int(viewModel.progress.percent)) + " %")
                ProgressBar(value: viewModel.progress.percent/100)
                    .frame(width: geometry.size.width*2/3, height: 10)
            }
        }
    }
}

// MARK: - Appearance

private extension InterestStateView {
    struct Appearance {
        let titleColor = Color("secondaryText")
    }
}
