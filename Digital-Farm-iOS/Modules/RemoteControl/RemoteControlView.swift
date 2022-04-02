//
//  RemoteControlView.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 07.02.2022.
//

import SwiftUI

struct RemoteControlView<ViewModel: RemoteControlViewModelProtocol>: View {
    
    // MARK: - Private properties
    @ObservedObject private var viewModel: ViewModel
    private let appearance = Appearance()
    
    // MARK: - Init
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                
                VStack {
                    Button(action: {
                        print("Top Tapped!")
                    }) {
                        Image(uiImage: UIImage(named: "up-arrow")!)
                    }
                    HStack(spacing: 90) {
                        Button(action: {
                            print("Left Tapped!")
                        }) {
                            Image(uiImage: UIImage(named: "left-arrow")!)
                        }
                        Button(action: {
                            print("Rigth Tapped!")
                        }) {
                            Image(uiImage: UIImage(named: "right-arrow")!)
                        }
                    }
                    Button(action: {
                        print("Down Tapped!")
                    }) {
                        Image(uiImage: UIImage(named: "down-arrow")!)
                    }
                    Spacer()
                    HStack {
                        createBaseActionButton(title: appearance.startTitle) {
                            // TO-DO: Start action
                        }
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        createBaseActionButton(title: appearance.returnTitle) {
                            // TO-DO: Return action
                        }
                        .background(Color.white)
                        .foregroundColor(.red)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red, lineWidth: 1)
                        )
                    }
                }
            }
        }
        .navigationTitle(appearance.title)
    }
}

// MARK: - Private extension
private extension RemoteControlView {
    func createBaseActionButton(
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.vertical, 12)
                .padding(.horizontal, 54)
                .font(.headline)
        }
    }
}

// MARK: - Appearance
private extension RemoteControlView {
    struct Appearance {
        let title = Localized("FeedPusher.RemoteControl.Title")
        let startTitle = Localized("FeedPusher.Start.Title")
        let returnTitle = Localized("FeedPusher.Return.Title")
    }
}
