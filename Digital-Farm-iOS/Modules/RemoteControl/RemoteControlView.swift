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
    private let rotationChangePublisher = NotificationCenter.default
        .publisher(for: UIDevice.orientationDidChangeNotification)
    @State private var isOrientationLocked = false
    
    @State private var topLeft: String = "360"
    @State private var topRight: String = "360"
    @State private var top: String = "360"
    @State private var left: String = ""
    @State private var right: String = ""
    @State private var bottomLeft: String = "360"
    @State private var bottomRight: String = "360"
    @State private var bottom: String = "360"
    
    @State private var leftAddition: String = "400"
    @State private var leftClockwise = true
    @State private var leftLoop = false
    
    @State private var rightAddition: String = "400"
    @State private var rightClockwise = true
    @State private var rightLoop = false
    
    @State private var screwAddition: String = "400"
    @State private var screwClockwise = true
    @State private var screwLoop = false
    
    @State private var batcherAddition: String = "400"
    @State private var batcherClockwise = true
    @State private var batcherLoop = false
    
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
                    // Spacer()
                    ScrollView {
                        HStack(alignment: .center) {
                            createMotionControlView()

                            Spacer(minLength: 50)
                            
                            
                            Divider()
                            
                            
                            
                            // Дополнительное меню
                            VStack {
//                                HStack {
//                                    Button(action: {
//                                        let step: String
//                                        if leftAddition.count > 4 {
//                                            step = String(leftAddition.prefix(4))
//                                        } else {
//                                            step = String(repeating: "0", count: 4 - leftAddition.count) + leftAddition
//                                        }
//                                        viewModel.sendToServer(command: "+WL" +
//                                                               (leftClockwise ? ">" : "<") +
//                                                               (leftLoop ? ":L000:" : ":\(step):")
//                                        )
//                                    }) {
//                                        Text("Left")
//                                            .frame(width: 100, alignment: .center)
//                                    }
//                                    .padding()
//                                    .foregroundColor(.white)
//                                    .background(Color.blue)
//                                    .cornerRadius(8)
//
//                                    HStack {
//                                        ScalableText("STEP:")
//                                        TextField("0-100", text: $leftAddition) { UIApplication.shared.endEditing() }
//                                        .frame(width: 50, height: 50)
//                                        .keyboardType(.numberPad)
//                                    }
//                                    .padding()
//
//                                    VStack {
//                                        ScalableText("LOOP:")
//                                        Toggle("Loop:", isOn: $leftLoop)
//                                            .labelsHidden()
//                                    }
//                                    .padding()
//
//                                    VStack {
//                                        ScalableText("CLOCKWISE:")
//                                        Toggle("", isOn: $leftClockwise)
//                                            .labelsHidden()
//                                    }
//                                    .padding()
//                                }
//                                .padding()
                                
//                                HStack {
//                                    Button(action: {
//                                        let step: String
//                                        if rightAddition.count > 4 {
//                                            step = String(rightAddition.prefix(4))
//                                        } else {
//                                            step = String(repeating: "0", count: 4 - rightAddition.count) + rightAddition
//                                        }
//                                        viewModel.sendToServer(command: "+WR" +
//                                                               (rightClockwise ? ">" : "<") +
//                                                               (rightLoop ? ":L000:" : ":\(step):")
//                                        )
//                                    }) {
//                                        Text("Right")
//                                            .frame(width: 100, alignment: .center)
//                                    }
//                                    .padding()
//                                    .foregroundColor(.white)
//                                    .background(Color.blue)
//                                    .cornerRadius(8)
//                                    HStack {
//                                        ScalableText("STEP:")
//                                        TextField("0-100", text: $rightAddition) { UIApplication.shared.endEditing() }
//                                        .frame(width: 50, height: 50)
//                                        .keyboardType(.numberPad)
//                                    }
//                                    .padding()
//                                    VStack {
//                                        ScalableText("LOOP:")
//                                        Toggle("", isOn: $rightLoop)
//                                            .labelsHidden()
//                                    }
//                                    .padding()
//                                    VStack {
//                                        ScalableText("CLOCKWISE:")
//                                        Toggle("", isOn: $rightClockwise)
//                                            .labelsHidden()
//                                    }
//                                    .padding()
//                                }
//                                .padding()
                                
//                                HStack {
//                                    Button(action: {
//                                        let step: String
//                                        if screwAddition.count > 4 {
//                                            step = String(screwAddition.prefix(4))
//                                        } else {
//                                            step = String(repeating: "0", count: 4 - screwAddition.count) + screwAddition
//                                        }
//                                        viewModel.sendToServer(command: "+S0" +
//                                                               (screwClockwise ? ">" : "<") +
//                                                               (screwLoop ? ":L000:" : ":\(step):")
//                                        )
//                                    }) {
//                                        Text("Screw")
//                                            .frame(width: 100, alignment: .center)
//                                    }
//                                    .padding()
//                                    .foregroundColor(.white)
//                                    .background(Color.blue)
//                                    .cornerRadius(8)
//                                    HStack {
//                                        ScalableText("STEP:")
//                                        TextField("0-100", text: $screwAddition) { UIApplication.shared.endEditing() }
//                                        .frame(width: 50, height: 50)
//                                        .keyboardType(.numberPad)
//                                    }
//                                    .padding()
//                                    VStack {
//                                        ScalableText("LOOP:")
//                                        Toggle("LOOP:", isOn: $screwLoop)
//                                            .labelsHidden()
//                                    }
//                                    .padding()
//
//                                    VStack {
//                                        ScalableText("CLOCKWISE:")
//                                        Toggle("", isOn: $screwClockwise)
//                                            .labelsHidden()
//                                    }
//                                    .padding()
//                                }
//                                .padding()
                                
//                                HStack {
//                                    Button(action: {
//                                        let step: String
//                                        if batcherAddition.count > 4 {
//                                            step = String(batcherAddition.prefix(4))
//                                        } else {
//                                            step = String(repeating: "0", count: 4 - batcherAddition.count) + batcherAddition
//                                        }
//                                        viewModel.sendToServer(command: "+B0" +
//                                                               (batcherClockwise ? ">" : "<") +
//                                                               (batcherLoop ? ":L000:" : ":\(step):")
//                                        )
//                                    }) {
//                                        Text("Batcher")
//                                            .frame(width: 100, alignment: .center)
//                                    }
//                                    .padding()
//                                    .foregroundColor(.white)
//                                    .background(Color.blue)
//                                    .cornerRadius(8)
//                                    HStack {
//                                        ScalableText("STEP:")
//                                        TextField("0-100", text: $batcherAddition) { UIApplication.shared.endEditing() }
//                                        .frame(width: 50, height: 50)
//                                        .keyboardType(.numberPad)
//                                    }
//                                    .padding()
//                                    VStack {
//                                        ScalableText("LOOP:")
//                                        Toggle("LOOP:", isOn: $batcherLoop)
//                                            .labelsHidden()
//                                    }
//                                    .padding()
//
//                                    VStack {
//                                        ScalableText("CLOCKWISE:")
//                                        Toggle("", isOn: $batcherClockwise)
//                                            .labelsHidden()
//                                    }
//                                    .padding()
//                                }
//                                .padding()
                                
                                
//                                HStack {
//                                    InterestStateView(
//                                        viewModel: InterestStateViewModel(
//                                            progress: .init(
//                                                title: "Battery",
//                                                percent: 25
//                                            )
//                                        )
//                                    )
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                                    VStack {
//                                        HStack {
//                                            Rectangle()
//                                                .fill(.green)
//                                                .frame(width: 20, height: 20)
//                                            Text("Sensor 1")
//                                        }
//
//                                        HStack {
//                                            Rectangle()
//                                                .fill(.green)
//                                                .frame(width: 20, height: 20)
//                                            Text("Sensor 2")
//                                        }
//
//                                        HStack {
//                                            Rectangle()
//                                                .fill(.red)
//                                                .frame(width: 20, height: 20)
//                                            Text("Sensor 3")
//                                        }
//                                    }
//                                }
//
//                                .padding()
                            }
                        }
                    }
                    

                    // Spacer(minLength: 100)
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
                
                
            )
        }
    }
}

// MARK: - Private extension
private extension RemoteControlView {
    func createMotionControlView() -> some View {
        VStack {
            HStack {
                VStack {
                    // Поворт лево-вперед
                    HStack {
                        TextField("-", text: $topLeft) { UIApplication.shared.endEditing() }
                        .frame(width: 35)
                        .keyboardType(.numberPad)
                        .padding()
                        createMainButton(-135)
                    }
                    
                    // Поворт лево-назад
                    HStack {
                        TextField("-", text: $bottomLeft) { UIApplication.shared.endEditing() }
                        .frame(width: 35)
                        .keyboardType(.numberPad)
                        .padding()
                        createMainButton(135)
                    }
                }
                
                VStack {
                    // Поворт вперед
                    VStack {
                        TextField("-", text: $top) { UIApplication.shared.endEditing() }
                        .frame(width: 35)
                        .keyboardType(.numberPad)
                        .padding()
                        createMainButton(-90)
                    }
                    
                    // Сброс
                    VStack {
                        Button {
                            print("close")
                        } label: {
                            Image("remove")
                        }
                    }
                    
                    // Поворт назад
                    VStack {
                        createMainButton(90)
                        TextField("-", text: $bottom) { UIApplication.shared.endEditing() }
                        .frame(width: 35)
                        .keyboardType(.numberPad)
                        .padding()
                    }
                }
                
                VStack {
                    // Поворт право-вперед
                    HStack {
                        createMainButton(-45)
                        TextField("-", text: $topRight) { UIApplication.shared.endEditing() }
                        .frame(width: 35)
                        .keyboardType(.numberPad)
                        .padding()
                    }
                    
                    // Поворт право-назад
                    HStack {
                        createMainButton(45)
                        TextField("-", text: $bottomRight) { UIApplication.shared.endEditing() }
                        .frame(width: 35)
                        .keyboardType(.numberPad)
                        .padding()
                    }
                }
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
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func createMainButton(_ rotateAngle: Double, action: @escaping () -> Void = {}) -> some View {
        Button(action: action) {
            Image("right-arrow-4")
                .rotationEffect(.degrees(rotateAngle))
                .frame(width: 40, height: 40, alignment: .center)
        }
        .frame(width: 60, height: 60, alignment: .center)
        .background(Color.blue)
        .cornerRadius(10)
    }
    
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
