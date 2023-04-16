//
//  ScheduleView.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 02.04.2022.
//

import SwiftUI

struct ScheduleView<ViewModel: ScheduleViewModel>: View {
    // MARK: - Private properties
    @State private var newTime = Date()
    @ObservedObject private var viewModel: ViewModel
    private let appearance = Appearance()
    
    // MARK: - Init
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Content
    var body: some View {
        content.navigationTitle(appearance.title)
        .onAppear(perform: {
            viewModel.fetchSchedule()
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
        case .loaded(let schedulesTimes):
            return AnyView(
                VStack {
                    List {
                        HStack {
                            Text(appearance.timeTitle)
                                .foregroundColor(Color.gray)
                            Spacer()
                            Text(appearance.availabilityTitle)
                                .foregroundColor(Color.gray)
                        }
                        ForEach(schedulesTimes, id: \.id) { element in
                            var elementToggle = element
                            let binding = Binding(
                                get: { elementToggle.isEnabled },
                                set: { elementToggle.isEnabled = $0 }
                            )
                            HStack {
                                Text(element.time)
                                Toggle("", isOn: binding)
                                    .tint(.green)
                                    .onTapGesture {
                                        viewModel.changeAvailability(timeID: element.id, newValue: !elementToggle.isEnabled)
                                    }
                            }.swipeActions(allowsFullSwipe: true, content: {
                                Button(appearance.deleteTitle) {
                                    viewModel.deleteTime(timeID: element.id)
                                }
                            }).tint(.red)
                        }
                    }
                    Spacer()
                    HStack {
                        VStack {
                            Text(appearance.addTimeTitle)
                            DatePicker("", selection: $newTime, displayedComponents: .hourAndMinute)
                        }.labelsHidden()
                        
                        Button(action: {
                            viewModel.addTime(time: dateFormatter.string(from: newTime))
                            newTime = dateFormatter.date(from: "00:00")!
                        }) {
                            Image("plus")
                                .renderingMode(.template)
                                .frame(width: 50, height: 50)
                                .tint(Color.white)
                                .background(Color("addButton"))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.all, 13)
                }
            )
        }
    }
}

// MARK: - Private
private extension ScheduleView {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
}

// MARK: - Appearance

private extension ScheduleView {
    struct Appearance {
        let title = Localized("FeedPusher.Schedule.Title")
        let timeTitle = Localized("FeedPusher.Schedule.Time.Title")
        let availabilityTitle = Localized("FeedPusher.Schedule.Availability.Title")
        let addTimeTitle = Localized("FeedPusher.Schedule.PickTime.Title")
        let deleteTitle = Localized("FeedPusher.Schedule.Time.Delete")
    }
}
