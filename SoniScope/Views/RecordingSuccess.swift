import SwiftUI

struct RecordingSuccess: View {
    var onNext: () -> Void  // closure passed in by SessionFlowController

    var body: some View {
        ZStack {
            // Background elements
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 482, height: 104)
                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                .offset(y: -410)
            
            // Header
            ZStack {
                Text("Session")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 50)
            .padding(.top, 10)
            .offset(y: -382)
            
            VStack {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 96, weight: .medium))
                    .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                    .padding(10)
                
                Text("Analysis\nComplete")
                    .font(.system(size: 37, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
            }
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        .background(.black)
        .onAppear {
            // Auto-advance after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                onNext()
            }
        }
    }
}

#Preview {
    RecordingSuccess {
        print("Next triggered from preview")
    }
}
