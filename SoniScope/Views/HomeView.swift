import SwiftUI


struct HomeView: View {
    @Bindable var accessoryManager: AccessorySessionManager
    @State private var navigateToStartView = false

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date()).uppercased()
    }

    var body: some View {
        NavigationStack {
            VStack {
                // MARK: Top Bar
                HeaderView(title: "SoniScope")

                Spacer()

                // MARK: Pair Button with Gradient
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.56, green: 0.79, blue: 0.9),
                            Color(red: 0.99, green: 0.52, blue: 0.0)
                        ]),
                        startPoint: UnitPoint(x: 0.25, y: -0.41),
                        endPoint: UnitPoint(x: 0.77, y: 1.52)
                    )
                    .frame(width: 360, height: 52)
                    .cornerRadius(10)

                    HStack {
                        Text("Pair SoniScope")
                            .font(.system(size: 18, weight: .semibold))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .frame(width: 360, height: 52)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        accessoryManager.presentPicker()
                    }

                    // Connection Status
                    if accessoryManager.connectionStatus != "Disconnected" {
                        VStack {
                            Spacer()
                            Text(accessoryManager.connectionStatus)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .frame(height: 340, alignment: .bottom)
                    }

                    // Hidden Navigation Trigger
                    NavigationLink(destination: StartView(), isActive: $navigateToStartView) {
                        EmptyView()
                    }
                }
                .onChange(of: accessoryManager.connectionStatus) {
                    if accessoryManager.connectionStatus == "Connected" {
                        navigateToStartView = true
                    }
                }

                Spacer(minLength: 200)
            }
            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .top)
            .background(Color.black)
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView(accessoryManager: AccessorySessionManager())
}
