//
//  DeviceCellView.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 12.01.2022.
//

import SwiftUI

struct DeviceCellView<ViewModel: DeviceCellViewModelProtocol>: View {
    // MARK: - Private properties
    @ObservedObject private(set) var viewModel: ViewModel
    private let appearance = Appearance()
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, content: {
            Image(uiImage: viewModel.device.image)
            Spacer(minLength: 20)
            Text(viewModel.device.name)
            Spacer(minLength: 5)
            Text(viewModel.device.statusText)
                .foregroundColor(viewModel.device.statusColor)
        })
        .frame(maxWidth: .infinity, idealHeight: 120, alignment: .leading)
        .padding(.all, CGFloat(13))
        .background(appearance.backgroundColor)
        .cornerRadius(17)
    }
}

// MARK: - Private extension

private extension DeviceCellView {
    struct Appearance {
        let backgroundColor = Color("sand")
    }
}
