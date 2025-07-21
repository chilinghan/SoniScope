import SwiftUI

struct ContentView: View {
    @State private var manager = AccessorySessionManager()
    @State private var dataHistory: [String] = []
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                VStack {
                    Image(systemName: "waveform")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .foregroundColor(.blue)
                    
                    Text("SoniScope")
                        .font(.system(size: 32, weight: .bold))
                }
                .padding(.vertical)
                
                // Connection Status
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(manager.peripheralConnected ? .green : .red)
                            .frame(width: 12, height: 12)
                        Text(manager.peripheralConnected ? "Connected" : "Disconnected")
                    }
                    Text(manager.connectionStatus)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Data Display
                VStack(alignment: .leading, spacing: 12) {
                    if manager.peripheralConnected {
                        if let audioData = manager.rawAudio {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("LIVE DATA")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(audioData)
                                    .font(.system(.title3, design: .monospaced).bold())
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 12)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(10)
                                
                                if !dataHistory.isEmpty {
                                    Divider()
                                    Text("RECENT VALUES")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    ScrollView {
                                        LazyVStack(alignment: .leading, spacing: 4) {
                                            ForEach(dataHistory.indices.reversed(), id: \.self) { index in
                                                Text(dataHistory[index])
                                                    .font(.system(.caption, design: .monospaced))
                                                    .padding(6)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .background(index % 2 == 0 ? Color.gray.opacity(0.1) : Color.clear)
                                                    .cornerRadius(4)
                                            }
                                        }
                                    }
                                    .frame(maxHeight: 150)
                                }
                            }
                        } else {
                            ProgressView("Waiting for data...")
                        }
                    } else {
                        Text("Connect your SoniScope to begin")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                
                Spacer()
                
                // Action Button
                Button {
                    manager.peripheralConnected ? manager.disconnect() : manager.presentPicker()
                } label: {
                    Label(
                        manager.peripheralConnected ? "Disconnect" : "Pair Device",
                        systemImage: manager.peripheralConnected ? "xmark.circle" : "link"
                    )
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("SoniScope")
            .alert("Pairing Failed", isPresented: $manager.showPairingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Could not connect to SoniScope. Please try again.")
            }
            .onChange(of: manager.rawAudio) { newValue in
                if let newValue {
                    dataHistory.append(newValue)
                    if dataHistory.count > 50 { dataHistory.removeFirst() }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
