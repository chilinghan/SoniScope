import SwiftUI

struct Session2: View {
    var onNext: () -> Void = {}
    var onEnd: () -> Void = {} // <-- Add this line

    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 482, height: 104)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .offset(y: -400)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 339, height: 412)
                    .background(
                        Image(.bodyLowRes)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 339 * 1.4, height: 412 * 1.4)
                            .clipped()
                    )
                    .offset(y: -90)
                
                
                ZStack {
                    Text("Session")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    Button(action: {
                                onEnd()
                                    }) {
                                        HStack(spacing: 3) {
                                            Image(systemName: "chevron.left")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                                            Text("End")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 65)
                .padding(.top, 10)
                .offset(y: -366)
                
                Circle()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                    .offset(x: -70, y: -210)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 402, height: 423)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(30)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: -10)
                    .offset(y: 260)
                
                Button(action: {
                    onNext()
                }) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 351, height: 45)
                            .background(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.99, green: 0.52, blue: 0), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.56, green: 0.79, blue: 0.9), location: 1.00),
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                        
                        Label("Next Step", systemImage: "arrow.right")
                            .font(.system(size: 18, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                }
                .offset(y: 310)
                
                HStack{
                    Text("Place SoniScope firmly against skin. Ensure good contact without excessive pressure.")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .padding(60)
                .offset(y: 200)

                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 370, height: 1)
                    .background(Color(red: 0.25, green: 0.25, blue: 0.27))
                    .offset(y: 130)
                
                ZStack {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.56, green: 0.79, blue: 0.9), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.99, green: 0.52, blue: 0), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0.17, y: 0.14),
                                    endPoint: UnitPoint(x: 0.84, y: 1)
                                )
                            )
                            .frame(width: 32, height: 32)
                        
                        Text("2")
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .frame(width: 15, height: 34, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Text("Apply SoniScope")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(60)
                .offset(y: 90)
            }
            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            .background(.black)
        }
    }
}

#Preview {
    Session2()
}
