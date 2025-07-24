import SwiftUI

struct RecordingSuccess: View {
    @EnvironmentObject var sessionManager: SessionManager
    var onNext: (SessionEntity) -> Void

    var body: some View {
        ZStack {
            // Background elements
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 482, height: 120)
                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                .offset(y: -400)

            // Header
            ZStack {
                Text("Session")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 65)
            .padding(.top, 10)
            .offset(y: -366)

            VStack {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 96, weight: .light))
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if let session = sessionManager.currentSession {
                    onNext(session)
                } else {
                    print("⚠️ No current session found in SessionManager")
                }
            }
        }
    }
}
