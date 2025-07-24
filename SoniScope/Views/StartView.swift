import SwiftUI

struct StartView: View {
    @Bindable var accessoryManager: AccessorySessionManager
    @State private var showSessionFlow = false

    var body: some View {
        VStack {
            // MARK: Top Bar
            HeaderView(title: "SoniScope")

            Spacer()

            // MARK: Start Session Button
            Button(action: {
                if accessoryManager.connectionStatus != "Connected" {
                    accessoryManager.presentPicker()
                    
                    Task {
                        while accessoryManager.connectionStatus != "Connected" {
                            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3s
                        }
                        if accessoryManager.connectionStatus == "Connected" {
                            showSessionFlow = true
                        }
                    }
                    
                } else {
                    showSessionFlow = true
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
//            if accessoryManager.connectionStatus != "Disconnected" {
//                Text(accessoryManager.connectionStatus)
//                    .font(.system(size: 14, weight: .medium))
//                    .foregroundColor(.white)
//                    .padding(.top, 10)
//            }

            Spacer(minLength: 200)
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .top)
        .background(Color.black)
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showSessionFlow) {
            SessionFlowView()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    StartView(accessoryManager: AccessorySessionManager())
}
