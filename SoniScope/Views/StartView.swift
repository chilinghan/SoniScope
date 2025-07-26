import SwiftUI

struct StartView: View {
    @Bindable var accessoryManager: AccessorySessionManager
    @State private var showSessionFlow = false
    @State private var startSessionPressed = false

    var body: some View {
        VStack {
            // MARK: Top Bar
            HeaderView(title: "SoniScope")
            
            Image(.render)
                .resizable()
                .frame(width: 700, height: 400)

            // MARK: Start Session Button
            Button(action: {
                if accessoryManager.connectionStatus != "Connected" {
                    startSessionPressed = true  // User pressed button to start pairing
                    accessoryManager.presentPicker()
                } else {
                    showSessionFlow = true      // Already connected, proceed immediately
                }
            }) {
                ZStack {
                    LinearGradient(
                        stops: [
                            .init(color: Color(red: 0.56, green: 0.79, blue: 0.9), location: 0.00),
                            .init(color: Color(red: 0.99, green: 0.52, blue: 0.0), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.74, y: 1.27),
                        endPoint: UnitPoint(x: 0.25, y: -0.43)
                    )
                    .frame(width: 320, height: 60)
                    .cornerRadius(60)

                    HStack {
                        Image(systemName: "play.fill")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Start Session")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .frame(width: 320, height: 60)
                }
            }

            // Optional: Show connection status
            if accessoryManager.connectionStatus != "Disconnected" {
                Text(accessoryManager.connectionStatus)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.top, 10)
            }
            
            Spacer()

        }
        .background(Color.black)
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showSessionFlow) {
            SessionFlowView()
        }
        .onChange(of: accessoryManager.connectionStatus) {
            // Only navigate if user pressed start AND connected now
            if startSessionPressed && accessoryManager.connectionStatus == "Connected" {
                showSessionFlow = true
                startSessionPressed = false  // reset flag
            }
        }
    }
}

#Preview {
    StartView(accessoryManager: AccessorySessionManager())
}
