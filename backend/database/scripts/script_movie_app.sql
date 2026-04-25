CREATE DATABASE IF NOT EXISTS movie_review_app;
USE movie_review_app;

-- 1. Eliminación de tablas existentes (Mantenimiento seguro)
-- Se eliminan en orden inverso a sus dependencias para evitar errores de claves foráneas.
DROP TABLE IF EXISTS Favoritos;
DROP TABLE IF EXISTS Refresh_Token;
DROP TABLE IF EXISTS Peliculas;
DROP TABLE IF EXISTS Usuarios;

-- 2. Creación de la tabla Usuarios
CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 3. Creación de la tabla Refresh_Token
CREATE TABLE Refresh_Token (
    id_token INT AUTO_INCREMENT PRIMARY KEY,
    token VARCHAR(500) UNIQUE NOT NULL,
    fecha_expiracion TIMESTAMP NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_id INT,
    revoked BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

-- 4. Creación de la tabla Peliculas
CREATE TABLE Peliculas (
    id_pelicula INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    poster_path VARCHAR(255),
    api_id INT UNIQUE NOT NULL,
    fecha_estreno DATE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Creación de la tabla Favoritos (Tabla Intermedia)
CREATE TABLE Favoritos (
    id_favorito INT AUTO_INCREMENT PRIMARY KEY,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_id INT,
    pelicula_id INT,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (pelicula_id) REFERENCES Peliculas(id_pelicula) ON DELETE CASCADE,
    UNIQUE (usuario_id, pelicula_id)
);