import SwiftUI

struct HealthDetailCardView: View {
    @EnvironmentObject var healthManager: HealthDataManager
    @EnvironmentObject var userManager: UserManager
    
    private var views: [AnyView] {
        [
            AnyView(infoRow(title: "First Name", value: userManager.fetchUserNameParts().firstName ?? "User")),
            AnyView(infoRow(title: "Last Name", value: userManager.fetchUserNameParts().lastName ?? "")),
            AnyView(infoRow(title: "Date of Birth", value: healthManager.dateOfBirth)),
            AnyView(infoRow(title: "Sex", value: healthManager.biologicalSex)),
            AnyView(infoRow(title: "Blood Type", value: healthManager.bloodType))
        ]
    }
    
    var body: some View {
        VStack(spacing: 25) {
            // Title
            Text("Health Details")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.top, 30)

            // Icon
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundColor(Color.orange)
                .padding(.vertical, 20)

            // Info Section
            VStack(spacing: 0) {
                ForEach(Array(views.enumerated()), id: \.offset) { index, view in
                    view
                    if index < views.count - 1 {
                        Divider()
                            .background(Color.gray.opacity(0.3))
                            .padding(.horizontal)
                    }
                }

            }
            .background(Color(red: 40 / 255, green: 40 / 255, blue: 43 / 255))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)

            Spacer()
        }
        .cornerRadius(30)
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.58))
            Spacer()
            Text(value)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.clear)
    }
}
