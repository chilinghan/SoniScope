import SwiftUI

struct StartView: View {
    @State private var showSessionFlow = false
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date()).uppercased()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Top bar
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(formattedDate)
                            .foregroundColor(.gray)
                            .font(.caption)
                        Text("SoniScope")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "person.circle")
                        .font(.system(size: 30))
                        .foregroundColor(.orange)
                }
                .padding(.horizontal)
                .padding(.top, 80)
                
                Spacer()
                
                // Button
                Button(action: {
                    showSessionFlow = true
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
                    
                    .fullScreenCover(isPresented: $showSessionFlow) {
                        SessionFlowView()
                    }
                    
                }
                
                Spacer(minLength: 200)

            }
            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .top)
            .background(Color.black)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    StartView()
}
