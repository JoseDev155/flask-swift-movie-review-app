import Foundation

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var is_loading = false
    @Published var reg_error: String?
    
    // Función principal para el botón REGISTRATE
    func registerUser(nombre: String, email: String, pass: String, fecha: String) {
        // Validación de campos vacíos
        guard !nombre.isEmpty, !email.isEmpty, !pass.isEmpty, !fecha.isEmpty else {
            self.reg_error = "Todos los campos son obligatorios."
            return
        }
        
        self.is_loading = true
        self.reg_error = nil
        
        Task {
            do {
                let response = try await APIManager.shared.register(nombre: nombre, email: email, pass: pass, fecha: fecha)
                
                self.is_loading = false
                if response.success {
                    print("Usuario registrado exitosamente: \(nombre)")
                    // Navegar a login
                    self.goToLogin()
                } else {
                    self.reg_error = response.message
                }
            
            } catch {
                
                self.is_loading = false
                self.reg_error = error.localizedDescription
            
            }
        }
    }
    
    // Función para el enlace "Ingresar"
    func goToLogin() {
        print("Navegando a la pantalla de Login...")
    }
}