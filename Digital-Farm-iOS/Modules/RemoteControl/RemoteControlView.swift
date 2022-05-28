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
    
    @State private var top: String = ""
    @State private var left: String = ""
    @State private var right: String = ""
    @State private var bottom: String = ""
    
    // MARK: - Init
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }
    
    // MARK: - Content
    var body: some View {
        content.navigationTitle(appearance.title)
        .onAppear(perform: {
            viewModel.connectToServer()
        })
    }
    
    private var content: some View {
        switch viewModel.state {
        case .loading:
            return AnyView(ProgressView())
        case .error(let error):
            return AnyView(
                Text(error.localizedDescription)
            )
        case .loaded:
            return AnyView(
                VStack {
                    Spacer()
                    HStack {
                        VStack {
                            ScrollView {
                                VStack(alignment: .center) {
                                    createMainButton("Вперед") {
                                        viewModel.sendToServer(command: "DF:" + top + ":")
                                        top = ""
                                    }
                                    TextField("Вперед", text: $top) { UIApplication.shared.endEditing() }
                                    .frame(width: 50, height: 50)
                                    .keyboardType(.numberPad)
                                    .padding(10)
                                }
                                
                                HStack(spacing: 90) {
                                    VStack(alignment: .center) {
                                        createMainButton("Влево") {
                                            viewModel.sendToServer(command: "DL:" + left + ":")
                                            left = ""
                                        }
                                        TextField("Влево", text: $left) { UIApplication.shared.endEditing() }
                                        .frame(width: 50, height: 50)
                                        .keyboardType(.numberPad)
                                        .padding(10)
                                    }
                                    
                                    VStack(alignment: .center) {
                                        createMainButton("Вправо") {
                                            viewModel.sendToServer(command: "DR:" + right + ":")
                                            right = ""
                                        }
                                        TextField("Вправо", text: $right) { UIApplication.shared.endEditing() }
                                        .frame(width: 50, height: 50)
                                        .keyboardType(.numberPad)
                                        .padding(10)
                                    }
                                }
                                
                                VStack(alignment: .center) {
                                    createMainButton("Назад") {
                                       viewModel.sendToServer(command: "DB:" + bottom + ":")
                                        bottom = ""
                                   }
                                    TextField("Назад", text: $bottom) { UIApplication.shared.endEditing() }
                                    .frame(width: 50, height: 50)
                                    .keyboardType(.numberPad)
                                    .padding(10)
                                }
                                Spacer(minLength: 10)
                                VStack {
                                    Text("Дополнительные функции")
                                    HStack {
                                        createMainButton("Ф1") {
                                            viewModel.sendToServer(command: "F1:")
                                        }
                                        createMainButton("Ф2") {
                                            viewModel.sendToServer(command: "F2:")
                                        }
                                        createMainButton("Ф3") {
                                            viewModel.sendToServer(command: "F3:")
                                        }
                                        createMainButton("Ф4") {
                                            viewModel.sendToServer(command: "F4:")
                                        }
                                    }
                                }
                                Spacer(minLength: 100)
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
                }
            )
        }
    }
}

// MARK: - Private extension
private extension RemoteControlView {
    func createMainButton(_ title: String, action: @escaping () -> Void = {}) -> some View {
        Button(action: action) {
            Text(title)
        }.buttonStyle(.borderedProminent)
    }
    
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
