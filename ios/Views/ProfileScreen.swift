import SwiftUI

struct ProfileScreen: View {
    @State private var bakeryName: String = "مخبز البدر"
    @State private var address: String = "عمان، وادي السير، الدوار السابع"
    @State private var phoneNumber: String = "+962 70 000 0000"
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color(red: 249/255, green: 242/255, blue: 228/255)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header with blurred background
                        ZStack(alignment: .top) {
                            AsyncImage(url: URL(string: "https://api.builder.io/api/v1/image/assets/TEMP/de10d90a694f734400b0d04df185773f2f050380?width=780")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color(red: 150/255, green: 86/255, blue: 65/255)
                            }
                            .frame(height: 125)
                            .clipped()
                            
                            Rectangle()
                                .fill(Color.black.opacity(0.01))
                                .background(.ultraThinMaterial)
                                .frame(height: 125)
                        }
                        
                        // Profile Image
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: Color.black.opacity(0.25), radius: 15, x: 0, y: 0)
                            .overlay(
                                AsyncImage(url: URL(string: "https://via.placeholder.com/120")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .foregroundColor(Color(red: 194/255, green: 94/255, blue: 62/255))
                                }
                                .clipShape(Circle())
                            )
                            .offset(y: -60)
                            .padding(.bottom, -40)
                        
                        // Form Fields
                        VStack(spacing: 16) {
                            // Bakery Name Field
                            FormFieldView(
                                label: "اسم المخبز",
                                value: $bakeryName
                            )
                            .padding(.top, 24)
                            
                            // Address Field
                            FormFieldView(
                                label: "العنوان",
                                value: $address
                            )
                            
                            // Phone Number Field
                            FormFieldView(
                                label: "رقم الهاتف",
                                value: $phoneNumber
                            )
                        }
                        .padding(.horizontal, 16)
                        
                        Spacer(minLength: 200)
                    }
                }
                
                // Bottom Button
                VStack {
                    Spacer()
                    
                    Button(action: {
                        // Edit action
                    }) {
                        Text("تعديل معلوماتي")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(red: 249/255, green: 242/255, blue: 228/255))
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color(red: 194/255, green: 94/255, blue: 62/255))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                    .background(
                        Color(red: 249/255, green: 242/255, blue: 228/255)
                            .shadow(color: Color.black.opacity(0.25), radius: 9, x: 0, y: -4)
                            .ignoresSafeArea(edges: .bottom)
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("الصفحة الشخصية")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

struct FormFieldView: View {
    let label: String
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            // Label
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(Color(red: 103/255, green: 57/255, blue: 42/255).opacity(0.5))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(red: 249/255, green: 242/255, blue: 228/255))
                .offset(y: 13)
                .padding(.trailing, 12)
                .zIndex(1)
            
            // Text Field
            TextField("", text: $value)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(red: 150/255, green: 86/255, blue: 65/255))
                .multilineTextAlignment(.trailing)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 150/255, green: 86/255, blue: 65/255), lineWidth: 1)
                )
        }
        .frame(height: 59)
    }
}

#Preview {
    ProfileScreen()
}
