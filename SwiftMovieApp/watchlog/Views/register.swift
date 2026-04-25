struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @State private var nombre = ""
    @State private var email = ""
    @State private var password = ""
    @State private var fecha = ""

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Crea una nueva\ncuenta")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                HStack {
                    Text("¿Ya te has registrado?")
                        .foregroundColor(.gray)
                    Button(action: { viewModel.goToLogin() }) {
                        Text("Ingresar")
                            .foregroundColor(.white)
                            .underline()
                    }
                }
                .font(.footnote)
                
                VStack(alignment: .leading, spacing: 5) {
                    CustomInputField(label: "Introduce tu nombre", text: $nombre, placeholder: "Jana Martin")
                    CustomInputField(label: "Ingresa un correo electrónico", text: $email, placeholder: "hola@unsitiogenial.es")
                    CustomInputField(label: "Introduce una contraseña", text: $password, placeholder: "******", is_secure: true)
                    CustomInputField(label: "Introduce tu fecha de nacimiento", text: $fecha, placeholder: "Fecha de nacimiento")
                    
                    if let error = viewModel.reg_error {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 5)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                Button(action: { viewModel.registerUser(nombre: nombre, email: email, pass: password, fecha: fecha) }) {
                    HStack {
                        if viewModel.is_loading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding(.trailing, 5)
                        }
                        Text("REGISTRATE")
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.2, green: 0.3, blue: 0.3))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.72, green: 0.84, blue: 0.78))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
        }
    }
}

// Componente reutilizable para los campos del registro
struct CustomInputField: View {
    var label: String
    @Binding var text: String
    var placeholder: String
    var is_secure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
            if is_secure {
                SecureField(placeholder, text: $text)
                    .modifier(InputStyle())
            } else {
                TextField(placeholder, text: $text)
                    .modifier(InputStyle())
            }
        }
        .padding(.vertical, 5)
    }
}

struct InputStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .foregroundColor(.black)
    }
}