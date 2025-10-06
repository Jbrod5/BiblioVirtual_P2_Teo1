-- Reinicio de la base de datos
DROP DATABASE IF EXISTS BiblioVirtual;
CREATE DATABASE BiblioVirtual;
USE BiblioVirtual;


-- Tabla de membresías
CREATE TABLE Membresia (
    id_membresia INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    descuento DOUBLE,
    precio DOUBLE
) ;
-- plata 5%, oro 7%, diamante 10%

-- Tabla de insignias
CREATE TABLE Insignia (
    id_insignia INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    descripcion TEXT
) ;

-- Tabla de roles de usuario
CREATE TABLE Rol_usuario (
    id_rol INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
) ;
-- administrador, cliente, moderador? (o sus funciones pueden ser de admin?), autor, un cliente normal es tambien autor????

-- Tabla de usuarios
CREATE TABLE Usuario (
    username VARCHAR(50) PRIMARY KEY,
    nombre VARCHAR(100),
    correo VARCHAR(255),
    contraseña VARCHAR(255),


    codigo_recuperacion VARCHAR(255),
    two_factor BOOLEAN DEFAULT FALSE, -- para indicar si tiene doble factor de autenticacion
    token_2fa VARCHAR(255), -- al iniciar sesion pedir este factor, al usarlo cambiarlo. Enviarlo por correo cuando se requiera :3

    rol INT,
    activo BOOLEAN DEFAULT TRUE, -- para no borrar los ussuariossss
    saldo DOUBLE DEFAULT 0,
    puntos INT DEFAULT 0,
    aprobado_autor BOOLEAN DEFAULT FALSE, -- el admin puede aprobarlo para subir publicaciones
    precio_suscripcion DOUBLE DEFAULT 0, -- cada autor debe decidir cuanto cuesta su suscripcion?????
    FOREIGN KEY (rol) REFERENCES Rol_usuario(id_rol)
) ;

-- Relación usuario-membresía
CREATE TABLE Usuario_membresia (
    usuario VARCHAR(50),
    membresia INT,
    inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fin TIMESTAMP NULL,
    PRIMARY KEY (usuario, membresia),
    FOREIGN KEY (usuario) REFERENCES Usuario(username),
    FOREIGN KEY (membresia) REFERENCES Membresia(id_membresia)
) ;
-- lista de todas las membresias :3

-- Relación usuario-insignia
CREATE TABLE Usuario_insignia (
    usuario VARCHAR(50),
    insignia INT,
    PRIMARY KEY (usuario, insignia),
    FOREIGN KEY (insignia) REFERENCES Insignia(id_insignia),
    FOREIGN KEY (usuario) REFERENCES Usuario(username)
) ;
-- un usuario puede tener una o más insignias :3

-- Tabla de tarjetas
CREATE TABLE Tarjetas (
    id_tarjeta INT PRIMARY KEY AUTO_INCREMENT,
    usuario VARCHAR(50),
    tarjeta BIGINT,
    FOREIGN KEY (usuario) REFERENCES Usuario(username)
) ;
-- lista de tarjetas que tienen los usuarios

-- Tabla de transacciones
CREATE TABLE Transaccion (
    id_transaccion INT PRIMARY KEY AUTO_INCREMENT,
    usuario VARCHAR(50),
    puntos BOOLEAN, -- verdadero si son puntos, falso si es saldo
    cantidad_transaccion DOUBLE, -- positivo si se ingresa, negativo si se egresa
    tarjeta INT NULL, -- puede ser nulo :3
    descripcion TEXT, -- descripcion de la transaccion
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario) REFERENCES Usuario(username),
    FOREIGN KEY (tarjeta) REFERENCES Tarjetas(id_tarjeta)
) ;
-- historial de transacciones, sirve tanto para saldo como puntos :3

CREATE TABLE Ingreso_plataforma (
    id_ingreso INT PRIMARY KEY AUTO_INCREMENT,
    usuario VARCHAR(50),
    fecha TIMESTAMP,
    descripcion TEXT,
    ingreso DOUBLE, 

    FOREIGN KEY (usuario) REFERENCES Usuario(username)
);
-- registro de todos los ingresos de la plataforma :3

-- Tabla de notificaciones
CREATE TABLE Notificaciones (
    id_notificacion INT PRIMARY KEY AUTO_INCREMENT,
    usuario VARCHAR(50),
    titulo_notificacion TEXT, -- para indicar 
    cuerpo_notificacion TEXT, -- expande la info de la notificacion :3
    FOREIGN KEY (usuario) REFERENCES Usuario(username)
) ;

-- Tabla de suscripciones (cliente → autor)
CREATE TABLE Suscripciones (
    cliente VARCHAR(50),
    autor VARCHAR(50),
    fecha_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_fin TIMESTAMP NULL,
    PRIMARY KEY (cliente, autor),
    FOREIGN KEY (cliente) REFERENCES Usuario(username),
    FOREIGN KEY (autor) REFERENCES Usuario(username)
) ;

-- Tabla de estados de publicación
CREATE TABLE Estado_publicacion (
    id_estado INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    descripcion TEXT
) ;
-- aprobado, rechazado, retirado

-- Tabla de categorías de publicación
CREATE TABLE Categoria_publicacion (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    descripcion TEXT
) ;

-- Tabla de publicaciones
CREATE TABLE Publicacion (
    id_publicacion INT PRIMARY KEY AUTO_INCREMENT,
    publica BOOLEAN DEFAULT TRUE,
    titulo VARCHAR(255),
    descripcion TEXT,
    categoria INT,
    contenido TEXT,
    url_archivo VARCHAR(255), -- url al archivo pdf, doc o lo que sea
    fecha_publicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    precio_saldo DOUBLE DEFAULT 0,
    precio_puntos DOUBLE DEFAULT 0,
    autor VARCHAR(50),
    estado INT,
    cantidad_reportes INT DEFAULT 0,
    calificacion_general DOUBLE DEFAULT 0,
    cantidad_compras INT DEFAULT 0,
    FOREIGN KEY (categoria) REFERENCES Categoria_publicacion(id_categoria),
    FOREIGN KEY (autor) REFERENCES Usuario(username),
    FOREIGN KEY (estado) REFERENCES Estado_publicacion(id_estado)
) ;

-- Tabla de publicaciones compradas
CREATE TABLE Publicaciones_compradas (
    usuario VARCHAR(50),
    publicacion INT,
    PRIMARY KEY (usuario, publicacion),
    FOREIGN KEY (usuario) REFERENCES Usuario(username),
    FOREIGN KEY (publicacion) REFERENCES Publicacion(id_publicacion)
) ;
-- para saber qué publicaciones ha comprado un usuario :3

-- Tabla de reseñas
CREATE TABLE Reseña_publicacion (
    publicacion INT,
    usuario VARCHAR(50),
    calificacion INT,
    reseña TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (publicacion, usuario),
    FOREIGN KEY (publicacion) REFERENCES Publicacion(id_publicacion),
    FOREIGN KEY (usuario) REFERENCES Usuario(username)
) ;
-- un usuario solo puede dejar una reseña por publicación

-- Tabla de reportes
CREATE TABLE Reporte_publicacion (
    id_reporte_publicacion INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    publicacion INT,
    usuario VARCHAR(50),
    descripcion TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (publicacion) REFERENCES Publicacion(id_publicacion),
    FOREIGN KEY (usuario) REFERENCES Usuario(username)
) ;
