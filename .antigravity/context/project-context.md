# Contexto General del Proyecto: CineInfo / MoviePlay SV

## Objetivo
Desarrollar una aplicación móvil nativa (CineInfo) que permita a los usuarios explorar, buscar y guardar información de películas de forma rápida e intuitiva, sin incluir funciones de reproducción o streaming. El sistema utiliza la API de TMDB para alimentar el catálogo.

## Estructura de Directorios
El proyecto se divide en tres repositorios/carpetas principales:
- `backend/`: API RESTful desarrollada en Python con Flask.
- `flutter_movie_app/`: Prototipo inicial en Flutter (basado en la modernización de un repositorio legacy).
- `MacMovieApp/`: Aplicación final nativa para iOS desarrollada en Swift.

## Flujo de Desarrollo Estratégico
1. **Backend First:** Desarrollo de la API en Flask conectada a MySQL.
2. **Modernización de Flutter:** Reescribir el repositorio legacy `flickd_rest_app_flutter` aplicando buenas prácticas actuales (Null Safety, manejo de estado moderno) e integrarlo con el backend de Flask.
3. **Migración a Swift:** Usar la app de Flutter como mapa de funcionamiento y prototipo funcional para codificar la versión final y oficial en Swift utilizando SwiftUI y arquitectura MVC.