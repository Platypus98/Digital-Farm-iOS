//
//  InterestStateViewModel.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 16.01.2022.
//

import Foundation

protocol InterestStateViewModelProtocol: ObservableObject {
    var progress: InterestState { get }
}

final class InterestStateViewModel: InterestStateViewModelProtocol {
    
    @Published private(set) var progress: InterestState
    
    init(progress: InterestState) {
        self.progress = progress
    }
}
