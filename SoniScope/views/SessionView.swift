import SwiftUI

struct SessionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var accessoryManager: AccessorySessionManager

    var step: Int = 0
    var title: String = ""
    var subtitle: String = ""
    var buttonText: String = ""
    var isChest: Bool = true
    
    var onNext: () -> Void = {}
    
    @State private var pulse = false

    var body: some View {
        VStack {
            
            if (isChest) {
                BodyImageWithPulsingDot().frame(width: 339, height: 412)
            } else {
                RecordingView(onNext: onNext).frame(width: 339, height: 412)
                    .onAppear {
                        accessoryManager.sendScreenCommand("recording")
                        accessoryManager.startRecordingToWAV()
                    }
            }


            StepCardView(stepNumber: step, title: title, subtitle: subtitle, buttonText: buttonText, onRecord: onNext)
        }
        .navigationTitle("Session")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Leading button
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.soniscopeBlue)
                        .font(.system(size: 20, weight: .semibold))
                }
            }
        }
        .background(.black)
        
    }
}

#Preview {
    NavigationStack{
        SessionView()
    }.preferredColorScheme(.dark)
}

