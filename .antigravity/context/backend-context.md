# Contexto del Backend (Flask + MySQL)

## Arquitectura y Estructura
El backend utiliza un patrón MVC Extendido. El código NO debe usar rutas absolutas, cada carpeta tendrá su archivo `__init__.py` para gestionar las importaciones relativas limpias.
Estructura base:
- `database/`: Conexión e inicialización de SQLAlchemy.
- `models/`: Definición de modelos ORM. No se requiere carpeta `schemas`; la serialización se maneja mediante Flask-Marshmallow nativo.
- `repositories/`: Capa de abstracción para las consultas directas a la base de datos.
- `routes/`: Controladores de los endpoints (Blueprints).
- `services/`: Lógica de negocio de la aplicación.

## Base de Datos
Se utiliza MySQL relacional para garantizar la integridad referencial. El esquema se limita a 4 tablas estrictas:
1. `Usuarios`: Gestión de perfiles y credenciales (con `password_hash`)
2. `Refresh_Token`: Gestión de sesiones JWT de larga duración vinculadas al usuario
3. `Peliculas`: Caché local de datos extraídos de la API de TMDB (contiene `api_id` único)
4. `Favoritos`: Tabla intermedia (M:N) con restricción UNIQUE compuesta para vincular `Usuarios` y `Peliculas`

## Stack Técnico Autorizado
- `Flask` & `Flask-SQLAlchemy` & `mysqlclient`
- Autenticación: `Flask-JWT-Extended` (Access y Refresh tokens)
- Seguridad: `Flask-Bcrypt` para el encriptado de contraseñas
- Validaciones: `Flask-Marshmallow`