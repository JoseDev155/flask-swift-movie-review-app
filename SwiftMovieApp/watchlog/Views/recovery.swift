import SwiftUI

struct RecoveryView: View {
    @StateObject private var viewModel = RecoveryViewModel()
    @State private var email = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    Text("¿Has olvidado tu contraseña?")
                        .font(.title3)
                        .foregroundColor(.white)
                    Text("Nueva contraseña")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 100)
                
                VStack(alignment: .leading) {
                    Text("Ingresa tu correo electrónico")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    TextField("hola@unsitiogenial.es", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        
                    if let alert = viewModel.alert_msg {
                        Text(alert)
                            .foregroundColor(.red)
                            .font(.caption2)
                            .padding(.top, 2)
                    }
                    if viewModel.show_conf {
                        Text("Correo enviado con éxito")
                            .foregroundColor(.green)
                            .font(.caption2)
                            .padding(.top, 2)
                    }
                }
                .padding(.horizontal, 40)
                
                Button(action: { viewModel.backToLogin() }) {
                    Text("Iniciar sesión")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.72, green: 0.84, blue: 0.78))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                
                Button(action: { viewModel.sendRecoveryEmail(email: email) }) { 
                    HStack {
                        if viewModel.is_loading {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .padding(.trailing, 5)
                                .scaleEffect(0.8)
                        }
                        Text("ENVIAR")
                    }
                }
                    .foregroundColor(.white)
                    .font(.caption)
                
                Spacer()
            }
        }
    }
}