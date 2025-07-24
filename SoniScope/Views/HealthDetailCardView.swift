import SwiftUI

struct HealthDetailCardView: View {
    @ObservedObject var healthData: HealthDataManager

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
//                infoRow(title: "First Name", value: healthData.firstName)
//                infoRow(title: "Last Name", value: healthData.lastName)
                infoRow(title: "Date of Birth", value: healthData.dateOfBirth)
                Divider()
                    .background(Color.gray.opacity(0.3))
                    .padding(.horizontal)
                
                infoRow(title: "Date of Birth", value: healthData.dateOfBirth)
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                    .padding(.horizontal)
                
                infoRow(title: "Date of Birth", value: healthData.dateOfBirth)
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                    .padding(.horizontal)
                
                infoRow(title: "Sex", value: healthData.biologicalSex)
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                    .padding(.horizontal)
                
                infoRow(title: "Blood Type", value: healthData.bloodType)
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
