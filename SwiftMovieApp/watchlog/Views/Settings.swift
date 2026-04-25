import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        ZStack {
            // Fondo oscuro para mantener la coherencia
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Cabecera personalizada
                headerView
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // SECCIÓN DE CUENTA
                        sectionHeader(title: "CUENTA")
                        SettingsRow(icon: "person.fill", title: "Perfil de usuario", subtitle: viewModel.user_name)
                        SettingsRow(icon: "envelope.fill", title: "Correo electrónico", subtitle: viewModel.user_email)
                        
                        // SECCIÓN DE PREFERENCIAS
                        sectionHeader(title: "PREFERENCIAS")
                        ToggleRow(icon: "bell.fill", title: "Notificaciones push", is_on: $viewModel.push_enabled)
                        ToggleRow(icon: "wifi", title: "Descargar solo con Wi-Fi", is_on: $viewModel.dl_wifi)
                        
                        // SECCIÓN DE SOPORTE
                        sectionHeader(title: "SOPORTE")
                        SettingsRow(icon: "questionmark.circle.fill", title: "Centro de ayuda")
                        SettingsRow(icon: "doc.text.fill", title: "Términos y Condiciones")
                        
                        Spacer().frame(height: 40)
                        
                        // BOTÓN DE SALIR
                        Button(action: {
                            viewModel.logout()
                        }) {
                            HStack {
                                Spacer()
                                if viewModel.is_logout {
                                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .padding(.trailing, 5)
                                }
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Cerrar sesión")
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red.opacity(0.8))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                        Text("MoviePlay SV v\(viewModel.app_version)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 10)
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // Componente de cabecera
    var headerView: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .font(.title3)
            }
            Spacer()
            Text("CONFIGURACIÓN")
                .font(.headline)
                .foregroundColor(.white)
                .tracking(2)
            Spacer()
            // Espaciador para centrar el título
            Color.clear.frame(width: 20, height: 20)
        }
        .padding()
        .background(Color.white.opacity(0.05))
    }
    
    func sectionHeader(title: String) -> some View {
        Text(title)
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.gray)
            .padding(.leading, 5)
    }
}

// COMPONENTES AUXILIARES

struct SettingsRow: View {
    var icon: String
    var title: String
    var subtitle: String? = nil
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.72, green: 0.84, blue: 0.78))
                .frame(width: 25)
            
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.white)
                    .font(.body)
                if let sub = subtitle {
                    Text(sub)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
    }
}

struct ToggleRow: View {
    var icon: String
    var title: String
    @Binding var is_on: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.72, green: 0.84, blue: 0.78))
                .frame(width: 25)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Toggle("", is_on: $is_on)
                .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.72, green: 0.84, blue: 0.78)))
        }
    }
}