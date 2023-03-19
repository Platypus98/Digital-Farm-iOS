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
    @State private var isMotionLoop = false
    
    @State private var screwAddition: String = "400"
    @State private var screwClockwise = true
    @State private var screwLoop = false
    
    @State private var batcherAddition: String = "400"
    @State private var batcherClockwise = true
    @State private var batcherLoop = false
    
    @State private var isScrewEn = true
    @State private var isBatcherEn = true
    @State private var isDriverLeftEn = true
    @State private var isDriverRightEn = true
    
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
                            Divider()
                            VStack {
                                createAdditionalControlView()
                                Divider()
                                HStack {
                                    createRegisterSetupView()
                                        .padding(10)
                                    Spacer(minLength: 10)
                                    createENSetupView()
                                        .padding(10)
                                }
                            }
                        }
                    }
                    
                    HStack {
                        createBaseActionButton(title: appearance.startTitle) {
                            viewModel.sendToServer(command: "#M71:0001:")
                        }
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        createBaseActionButton(title: appearance.returnTitle) {
                            viewModel.sendToServer(command: "#M71:0000:")
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
                        .frame(width: 45)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .padding()
                        MotionControlButton(-135) {
                            viewModel.sendToServer(command: "=DL<:"  + (isMotionLoop ? "L000:" : "\(topLeft.convertToComand()):"))
                        }
                    }
                    
                    // Поворт лево-назад
                    HStack {
                        TextField("-", text: $bottomLeft) { UIApplication.shared.endEditing() }
                        .frame(width: 45)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .padding()
                        MotionControlButton(135) {
                            viewModel.sendToServer(command: "=DL>:" + (isMotionLoop ? "L000:" : "\(bottomLeft.convertToComand()):"))
                        }
                    }
                }
                
                VStack {
                    // Поворт вперед
                    VStack {
                        TextField("-", text: $top) { UIApplication.shared.endEditing() }
                        .frame(width: 45)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .padding()
                        MotionControlButton(-90) {
                            viewModel.sendToServer(command: "=DF0:" + (isMotionLoop ? "L000:" : "\(top.convertToComand()):"))
                        }
                    }
                    
                    // Сброс
                    VStack {
                        Button {
                            viewModel.sendToServer(command: "=D00:0000:")
                        } label: {
                            Image("remove")
                        }
                    }
                    
                    // Поворт назад
                    VStack {
                        MotionControlButton(90) {
                            viewModel.sendToServer(command: "=DB0:" + (isMotionLoop ? "L000:" : "\(bottom.convertToComand()):"))
                        }
                        TextField("-", text: $bottom) { UIApplication.shared.endEditing() }
                        .frame(width: 45)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .padding()
                    }
                }
                
                VStack {
                    // Поворт право-вперед
                    HStack {
                        MotionControlButton(-45) {
                            viewModel.sendToServer(command: "=DR>:" + (isMotionLoop ? "L000:" : "\(topRight.convertToComand()):"))
                        }
                        TextField("-", text: $topRight) { UIApplication.shared.endEditing() }
                        .frame(width: 45)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .padding()
                    }
                    
                    // Поворт право-назад
                    HStack {
                        MotionControlButton(45) {
                            viewModel.sendToServer(command: "=DR<:" + (isMotionLoop ? "L000:" : "\(bottomRight.convertToComand()):"))
                        }
                        TextField("-", text: $bottomRight) { UIApplication.shared.endEditing() }
                        .frame(width: 45)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .padding()
                    }
                }
            }
            
            Spacer(minLength: 10)
            HStack {
                ScalableText("LOOP:")
                Toggle("Loop:", isOn: $isMotionLoop).labelsHidden()
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func createAdditionalControlView() -> some View {
        VStack {
            // MARK: - Screw
            HStack {
                AdditionalControlButton("Screw") {
                    viewModel.sendToServer(command: "+S0" + (screwClockwise ? ">" : "<") + (screwLoop ? ":L000:" : ":\(screwAddition.convertToComand()):"))
                }
                
                Button(action: {
                    viewModel.sendToServer(command: "+S00:0000:")
                }) {
                    Image("remove")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                
                HStack {
                    ScalableText("STEP:")
                    TextField("0-100", text: $screwAddition) { UIApplication.shared.endEditing() }
                    .frame(width: 45)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                }
                .padding()
                
                VStack {
                    ScalableText("LOOP:")
                    Toggle("Loop:", isOn: $screwLoop)
                        .labelsHidden()
                }
                .padding()
                
                VStack {
                    ScalableText("CLOCKWISE:")
                    HStack {
                        Text("L")
                            .bold()
                        Toggle("", isOn: $screwClockwise)
                            .labelsHidden()
                        Text("R")
                            .bold()
                    }
                }
                .padding()
            }
            
            // MARK: - Batcher
            HStack {
                AdditionalControlButton("Batcher") {
                    viewModel.sendToServer(command: "+B0" + (batcherClockwise ? ">" : "<") + (batcherLoop ? ":L000:" : ":\(batcherAddition.convertToComand()):"))
                }
                Button(action: {
                    viewModel.sendToServer(command: "+B00:0000:")
                }) {
                    Image("remove")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                
                HStack {
                    ScalableText("STEP:")
                    TextField("0-100", text: $batcherAddition) { UIApplication.shared.endEditing() }
                    .frame(width: 45)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                }
                .padding()
                
                VStack {
                    ScalableText("LOOP:")
                    Toggle("Loop:", isOn: $batcherLoop)
                        .labelsHidden()
                }
                .padding()
                
                VStack {
                    ScalableText("CLOCKWISE:")
                    HStack {
                        Text("L")
                            .bold()
                        Toggle("", isOn: $batcherClockwise)
                            .labelsHidden()
                        Text("R")
                            .bold()
                    }
                }
                .padding()
            }
        }
    }
    
    func createRegisterSetupView() -> some View {
        VStack {
            Text("REGISTER: 0000").bold()
            Text("VALUE: 0000").bold()
            Button(action: {}) {
                Text("READ")
                    .frame(width: 100, height: 15)
                    .padding()
                    .foregroundColor(.white)
            }
            .background(Color.blue)
            .cornerRadius(8)
            Button(action: {}) {
                Text("WRITE")
                    .frame(width: 100, height: 15)
                    .padding()
                    .foregroundColor(.white)
            }
            .background(Color.blue)
            .cornerRadius(8)
        }
    }
    
    func createENSetupView() -> some View {
        VStack(alignment: .leading) {
            // MARK: - ScrewEN
            HStack {
                Text("SCREW")
                    .bold()
                    .frame(width: 120, alignment: .leading)
                ScalableText("EN")
                Toggle("Loop:", isOn: $isScrewEn)
                    .labelsHidden()
                    .padding()
                    .onChange(of: isScrewEn) { value in
                        viewModel.sendToServer(command: "#M11" + (value ? ":0001:" : ":0000:"))
                    }
            }
            
            // MARK: - BatcherEN
            HStack {
                Text("BATCHER")
                    .bold()
                    .frame(width: 120, alignment: .leading)
                ScalableText("EN")
                Toggle("Loop:", isOn: $isBatcherEn)
                    .labelsHidden()
                    .padding()
                    .onChange(of: isBatcherEn) { value in
                        viewModel.sendToServer(command: "#M12" + (value ? ":0001:" : ":0000:"))
                    }
            }
            
            // MARK: - DriverLeftEN
            HStack {
                Text("Driver LEFT")
                    .bold()
                    .frame(width: 120, alignment: .leading)
                ScalableText("EN")
                Toggle("Loop:", isOn: $isDriverLeftEn)
                    .labelsHidden()
                    .padding()
                    .onChange(of: isDriverLeftEn) { value in
                        viewModel.sendToServer(command: "#M10" + (value ? ":0001:" : ":0000:"))
                    }
            }
            
            // MARK: - DriverRightEn
            HStack {
                Text("Driver RIGHT")
                    .bold()
                    .frame(width: 120, alignment: .leading)
                ScalableText("EN")
                Toggle("Loop:", isOn: $isDriverRightEn)
                    .labelsHidden()
                    .padding()
                    .onChange(of: isDriverRightEn) { value in
                        viewModel.sendToServer(command: "#M09" + (value ? ":0001:" : ":0000:"))
                    }
            }
        }
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

// MARK: - Additional Views
private extension RemoteControlView {
    struct MotionControlButton: View {
        let rotateAngle: Double
        let action: () -> Void
        
        init(
            _ rotateAngle: Double,
            action: @escaping () -> Void  = {}
        ) {
            self.rotateAngle = rotateAngle
            self.action = action
        }
        
        var body: some View {
            Button(action: action) {
                Image("right-arrow-4")
                    .rotationEffect(.degrees(rotateAngle))
                    .frame(width: 40, height: 40, alignment: .center)
            }
            .frame(width: 60, height: 60, alignment: .center)
            .background(Color.blue)
            .cornerRadius(10)
        }
    }
    
    struct AdditionalControlButton: View {
        let title: String
        let action: () -> Void
        
        init(
            _ title: String,
            action: @escaping () -> Void  = {}
        ) {
            self.title = title
            self.action = action
        }
        
        var body: some View {
            Button(action: action) {
                Text(title)
                    .frame(width: 100, height: 15)
                    .padding()
                    .foregroundColor(.white)
            }
            .background(Color.blue)
            .cornerRadius(8)
            .padding()
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
