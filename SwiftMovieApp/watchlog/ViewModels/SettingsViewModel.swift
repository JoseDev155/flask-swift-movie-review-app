import Foundation
import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    // Datos de Usuario (Deuda técnica: Deberían venir de un UserSessionManager)
    @Published var user_name: String = "Jana Martin"
    @Published var user_email: String = "hola@unsitiogenial.es"
    @Published var app_version: String = "1.0.0"
    
    // Preferencias con Persistencia (UserDefaults)
    // Usamos @AppStorage para que los cambios se guarden automáticamente en el disco
    @AppStorage("notifications_enabled") var push_enabled: Bool = true
    @AppStorage("download_over_wifi") var dl_wifi: Bool = true
    
    // Estados de flujo
    @Published var is_logout = false
    
    func logout() {
        self.is_logout = true
        
        // Simulación de limpieza de tokens/sesión
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UserDefaults.standard.removeObject(forKey: "auth_token")
            UserDefaults.standard.removeObject(forKey: "refresh_token")
            print("Sesión cerrada para: \(self.user_email)")
            // Aquí dispararías la lógica para volver a la LoginView
            self.is_logout = false
        }
    }
    
    func openHelpCenter() {
        if let url = URL(string: "https://movieplay.sv/help") {
            // Lógica para abrir safari o soporte
            print("Abriendo centro de ayuda...")
        }
    }
    
    func openTerms() {
        print("Cargando términos y condiciones...")
    }
    
    // Método para actualizar perfil (Ejemplo de escalabilidad)
    func updateProfile() {
        print("Navegando a edición de perfil...")
    }
}