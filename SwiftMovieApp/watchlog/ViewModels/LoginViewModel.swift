import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    // Estas propiedades se vinculan directamente a tus @State mediante lógica de negocio
    @Published var is_loading = false
    @Published var error_msg: String?
    
    // Función para el botón "Iniciar sesión"
    func login(email: String, pass: String) {
        // Validación básica de seguridad
        guard !email.isEmpty && !pass.isEmpty else {
            self.error_msg = "Campos vacíos"
            return
        }
        
        self.is_loading = true
        self.error_msg = nil
        
        Task {
            do {
                let response = try await APIManager.shared.login(email: email, pass: pass)
                
                self.is_loading = false
                print("Intento de login exitoso para: \(response.user_name) (\(response.email))")
                // Guardar tokens
                UserDefaults.standard.set(response.token, forKey: "auth_token")
                if let refresh = response.refresh_token {
                    UserDefaults.standard.set(refresh, forKey: "refresh_token")
                }
            
            } catch {
                
                self.is_loading = false
                self.error_msg = error.localizedDescription
            
            }
        }
    }
    
    func recoverPassword(for email: String) {
        guard !email.isEmpty else { return }
        
        Task {
            do {
                let success = try await APIManager.shared.recoverPassword(email: email)
                if success {
                    print("Enviando recuperación a: \(email)")
                }
            } catch {
                print("Error de recuperación: \(error.localizedDescription)")
            }
        }
    }
}