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
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, content: {
            Image(uiImage: viewModel.device.image)
            Spacer(minLength: 20)
            Text(viewModel.device.name)
            Spacer(minLength: 10)
            Text(viewModel.device.status.value)
        })
        .padding(.all, CGFloat(13))
        .background(Color("sand"))
        .cornerRadius(17)
    }
}
