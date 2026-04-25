import Foundation

// MARK: - Configuración Global de la API
struct APIConfig {
    // Configura aquí la URL de tu servidor Flask cuando esté listo para producción.
    // Ejemplos: "http://127.0.0.1:5000/api", "http://192.168.1.50:5000/api", "https://miservidor.com/api"
    static let base_url = "http://127.0.0.1:5000/api"
    
    // Cambia esto a `true` cuando quieras que la app intente conectarse al servidor Flask real.
    // Mientras sea `false`, devolverá respuestas simuladas para que puedas probar la UI.
    static let use_real_api = false
}

// MARK: - Modelos de Datos (Respuestas del Servidor Flask)
struct LoginResponse: Codable {
    let token: String
    let refresh_token: String?
    let user_name: String
    let email: String
}

struct RegisterResponse: Codable {
    let success: Bool
    let message: String
}

struct MovieResponse: Codable {
    let id: String
    let title: String
    let poster_url: String
    let quality: String
}

// MARK: - Manejo de Errores
enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(String)
    case decodingError
    
    var errorDescription: String? {
        if case .invalidURL = self { return "URL del servidor inválida." }
        if case .invalidResponse = self { return "Respuesta inválida del servidor." }
        if case .serverError(let msg) = self { return msg }
        if case .decodingError = self { return "Error procesando los datos." }
        return "Error desconocido." 
    }
}

// MARK: - Gestor de la API (Singleton)
class APIManager {
    static let shared = APIManager()
    private init() {}
    
    // Función base genérica para peticiones HTTP
    private func request<T: Codable>(endpoint: String, method: String, body: [String: Any]? = nil) async throws -> T {
        guard let url = URL(string: APIConfig.base_url + endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.http_method = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Si tienes un Token guardado (ej. UserDefaults), inyéctalo aquí:
        if let token = UserDefaults.standard.string(forKey: "auth_token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http_resp = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if !(200...299).contains(http_resp.statusCode) {
            // Se puede hacer decodificación de mensajes de error de Flask si la API lo envía estructurado.
            throw APIError.serverError("Error HTTP: \(http_resp.statusCode)")
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
    
    // MARK: - Endpoints para los ViewModels
    
    func login(email: String, pass: String) async throws -> LoginResponse {
        if APIConfig.use_real_api {
            let body: [String: Any] = ["email": email, "password": pass]
            return try await request(endpoint: "/login", method: "POST", body: body)
        } else {
            // --- SIMULACIÓN (Borrar en producción) ---
            try await Task.sleep(nanoseconds: 1_500_000_000)
            if email.contains("@") && pass.count >= 6 {
                return LoginResponse(token: "fake_token_123", refresh_token: "fake_refresh_token_456", user_name: "Jana Martin", email: email)
            } else {
                throw APIError.serverError("Credenciales incorrectas")
            }
        }
    }
    
    func register(nombre: String, email: String, pass: String, fecha: String) async throws -> RegisterResponse {
        if APIConfig.use_real_api {
            let body: [String: Any] = ["nombre": nombre, "email": email, "password": pass, "fechaNacimiento": fecha]
            return try await request(endpoint: "/register", method: "POST", body: body)
        } else {
            // --- SIMULACIÓN ---
            try await Task.sleep(nanoseconds: 1_500_000_000)
            if email.contains("@") {
                return RegisterResponse(success: true, message: "Usuario creado con éxito")
            } else {
                throw APIError.serverError("Formato de correo no válido")
            }
        }
    }
    
    func recoverPassword(email: String) async throws -> Bool {
        if APIConfig.use_real_api {
            let body: [String: Any] = ["email": email]
            let response: RegisterResponse = try await request(endpoint: "/recover", method: "POST", body: body)
            return response.success
        } else {
            // --- SIMULACIÓN ---
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return true
        }
    }
    
    func fetchMovies(category: String) async throws -> [MovieResponse] {
        if APIConfig.use_real_api {
            let endpoint = "/movies?category=\(category)"
            return try await request(endpoint: endpoint, method: "GET")
        } else {
            // --- SIMULACIÓN ---
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return (1...12).map { i in
                MovieResponse(
                    id: UUID().uuidString,
                    title: "\(category) \(i)",
                    poster_url: "https://ejemplo.com/poster\(i).jpg",
                    quality: i % 3 == 0 ? "CAM" : "HD"
                )
            }
        }
    }
}
