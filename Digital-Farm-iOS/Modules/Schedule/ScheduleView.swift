//
//  ScheduleView.swift
//  Digital-Farm-iOS
//
//  Created by Илья Голышков on 02.04.2022.
//

import SwiftUI

struct ScheduleView<ViewModel: ScheduleViewModel>: View {
    // MARK: - Private properties
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
        case .error:
            return AnyView(ProgressView())
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
                            }
                        }
                    }
                }
            )
        }
    }
}

// MARK: - Appearance

private extension ScheduleView {
    struct Appearance {
        let title = Localized("FeedPusher.Schedule.Title")
        let timeTitle = Localized("FeedPusher.Schedule.Time.Title")
        let availabilityTitle = Localized("FeedPusher.Schedule.Availability.Title")
    }
}
