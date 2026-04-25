import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Logo y Título
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(white: 0.8))
                        .frame(width: 60, height: 60)
                    VStack(alignment: .leading) {
                        Text("MOVIEPLAY")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        Text("S V")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 50)
                
                Spacer().frame(height: 40)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Bienvenido")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(red: 0.95, green: 0.92, blue: 0.88))
                        .cornerRadius(10)
                    
                    SecureField("Contraseña", text: $password)
                        .padding()
                        .background(Color(red: 0.95, green: 0.92, blue: 0.88))
                        .cornerRadius(10)
                        
                    if let error = viewModel.error_msg {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                .padding(.horizontal, 30)
                
                Button(action: { viewModel.login(email: email, pass: password) }) {
                    HStack {
                        if viewModel.is_loading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding(.trailing, 5)
                        }
                        Text("Iniciar sesión")
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.3))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.72, green: 0.84, blue: 0.78))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                
                Button(action: { viewModel.recoverPassword(for: email) }) {
                    Text("¿Olvidaste tu contraseña?")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
        }
    }
}