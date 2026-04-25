# Contexto del Frontend (Flutter & Swift)

## Fase 1: Flutter (Prototipo y Refactorización)
El objetivo en `flutter_movie_app/` es tomar una base legacy y modernizarla.
- **Reglas de modernización:** Se debe implementar "Null Safety" de forma estricta.
- **Manejo de Estado:** Utilizar un gestor moderno (Riverpod o Bloc) en lugar de arquitecturas obsoletas.
- **UI:** Migrar componentes a Material Design 3.
- **Integración:** Sustituir los endpoints originales o mockups por llamadas HTTP (usando el paquete `http` o `dio`) dirigidas al backend de Flask.

## Fase 2: Swift / iOS (Producto Final)
El desarrollo en `MacMovieApp/` es el objetivo final.
- **Lenguaje y UI:** Swift con SwiftUI para crear interfaces modernas y adaptables.
- **Arquitectura:** Modelo-Vista-Controlador (MVC).
  - *Modelo:* Uso del protocolo `Codable` para la serialización y deserialización de las respuestas JSON de Flask.
  - *Vista:* Desarrollada puramente en SwiftUI.
  - *Controlador:* Gestor de las llamadas HTTP REST.
- **Persistencia Local:** Se contempla el uso opcional de Core Data o SQLite para guardar información en caché y operar en modo offline.