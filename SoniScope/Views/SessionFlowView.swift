//
//  SessionFlowView.swift
//  SoniScope
//
//  Created by Chiling Han on 7/23/25.
//


import SwiftUI

struct SessionFlowView: View {
    @Environment(\.dismiss) var dismiss

    enum Step {
        case session1, session2, session3, recording, analyzing, success, results
    }

    @State private var step: Step = .session1

    var body: some View {
                switch step {
                case .session1:
                    Session1(onNext: { step = .session2 })
                case .session2:
                    Session2(onNext: { step = .session3 })
                case .session3:
                    Session3(onNext: { step = .recording })
                case .recording:
                    RecordingView(onNext: { step = .analyzing })
                case .analyzing:
                    AnalyzingView(onNext: { step = .success })
                case .success:
                    RecordingSuccess(onNext: { step = .results })
                case .results:
                    ResultsView(onFinish: { dismiss() })
            
        }
    }
}
