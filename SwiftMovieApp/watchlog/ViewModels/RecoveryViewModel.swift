import Foundation

@MainActor
class RecoveryViewModel: ObservableObject {
    @Published var is_loading = false
    @Published var show_conf = false
    @Published var alert_msg: String?
    
    // Función para el botón "ENVIAR"
    func sendRecoveryEmail(email: String) {
        // Validación de entrada
        guard !email.isEmpty else {
            self.alert_msg = "Por favor, ingresa tu correo electrónico."
            return
        }
        
        guard email.contains("@") else {
            self.alert_msg = "El formato del correo no es válido."
            return
        }
        
        self.is_loading = true
        self.alert_msg = nil
        self.show_conf = false
        
        Task {
            do {
                let success = try await APIManager.shared.recoverPassword(email: email)
                
                self.is_loading = false
                if success {
                    self.show_conf = true
                    print("Correo de recuperación enviado a: \(email)")
                }
            
            } catch {
                
                self.is_loading = false
                self.alert_msg = error.localizedDescription
            
            }
        }
    }
    
    // Función para el botón "Iniciar sesión" (Volver)
    func backToLogin() {
        print("Regresando a la pantalla de login...")
    }
}