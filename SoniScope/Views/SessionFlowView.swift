import SwiftUI

struct SessionFlowView: View {
    @EnvironmentObject var sessionManager: SessionManager

    enum Step {
        case session1, session2, session3, recording, success, analyzing, results
    }

    @State private var step: Step = .session1

    var body: some View {
        NavigationStack {
            switch step {
            case .session1:
                SessionView(
                    step: 1,
                    title: "Locate Placement",
                    subtitle: "Find the middle of your left torso, above your heart.",
                    buttonText: "Next Step",
                    onNext: { step = .session2 },
                )

            case .session2:
                SessionView(
                    step: 2,
                    title: "Apply SoniScope",
                    subtitle: "Place SoniScope firmly against skin. Ensure good contact without excessive pressure.",
                    buttonText: "Next Step",
                    onNext: { step = .session3 },
                )

            case .session3:
                SessionView(
                    step: 3,
                    title: "Record & Analyze",
                    subtitle: "Breathe normally and deeply. Maintain quiet environment during recording.",
                    buttonText: "Record",
                    onNext: {
                        step = .recording
                    },
                )

            case .recording:
                SessionView(
                    step: 4,
                    title: "Recording Session",
                    subtitle: "Breathe normally and deeply. Maintain quiet environment during recording.",
                    buttonText: "Recording in Progress...",
                    isChest: false,
                    onNext: {
                        step = .success
                    },
                )

            case .success:
                RecordingSuccess(
                    onNext: { _ in
                        step = .analyzing
                    }
                )
                
            case .analyzing:
                AnalyzingView(
                    onNext: { step = .results }
                )

            case .results:
                ResultsView(
                    session: sessionManager.currentSession!
                )
            }
        }
    }
}
