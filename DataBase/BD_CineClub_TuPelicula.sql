--drop database BD_CineClub_TuPelicula 
CREATE DATABASE BD_CineClub_TuPelicula;
GO
USE [BD_CineClub_TuPelicula];
GO

BEGIN TRANSACTION;
BEGIN TRY

-- === TABLAS MAESTRAS ===

-- 1. TIPO_DOCUMENTO
CREATE TABLE tipo_documento (
    id_tipo_documento INT PRIMARY KEY IDENTITY(1,1),
    descripcion NVARCHAR(50) NOT NULL
);

-- 2. CARGO
CREATE TABLE cargo (
    id_cargo INT PRIMARY KEY IDENTITY(1,1),
    descripcion NVARCHAR(100) NOT NULL
);

-- 3. ESTADO_CONSERVACION
CREATE TABLE estado_conservacion (
    id_estado_conservacion INT PRIMARY KEY IDENTITY(1,1),
    descripcion NVARCHAR(100) NOT NULL
);

-- 4. NACIONALIDAD
CREATE TABLE nacionalidad (
    id_nacionalidad INT PRIMARY KEY IDENTITY(1,1),
    pais NVARCHAR(100) NOT NULL
);

-- === TABLAS PRINCIPALES ===

-- 5. DIRECTOR
CREATE TABLE director (
    id_director INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    FK_id_nacionalidad INT,
    FOREIGN KEY (FK_id_nacionalidad) REFERENCES nacionalidad(id_nacionalidad)
);

-- 6. PELICULA
CREATE TABLE pelicula (
    id_pelicula INT PRIMARY KEY IDENTITY(1,1),
    titulo NVARCHAR(200) NOT NULL,
    FK_id_nacionalidad INT,
    productora NVARCHAR(100),
    fecha_estreno DATE,
    FK_id_director INT NOT NULL,
    FOREIGN KEY (FK_id_nacionalidad) REFERENCES nacionalidad(id_nacionalidad),
    FOREIGN KEY (FK_id_director) REFERENCES director(id_director)
);

-- 7. ACTOR
CREATE TABLE actor (
    id_actor INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    FK_id_nacionalidad INT,
    sexo CHAR(1) CHECK (sexo IN ('M', 'F')),
    FOREIGN KEY (FK_id_nacionalidad) REFERENCES nacionalidad(id_nacionalidad)
);

-- 8. PELICULA_ACTOR
CREATE TABLE pelicula_actor (
	id_pelicula_actor INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    FK_id_pelicula INT,
    FK_id_actor INT,
    es_principal BIT DEFAULT 0,
    FOREIGN KEY (FK_id_pelicula) REFERENCES pelicula(id_pelicula),
    FOREIGN KEY (FK_id_actor) REFERENCES actor(id_actor)
);

-- 9. EJEMPLAR
CREATE TABLE ejemplar (
    id_ejemplar INT PRIMARY KEY IDENTITY(1,1),
    FK_id_pelicula INT NOT NULL,
    numero_ejemplar INT NOT NULL,
    FK_id_estado_conservacion INT,
    FOREIGN KEY (FK_id_pelicula) REFERENCES pelicula(id_pelicula),
    FOREIGN KEY (FK_id_estado_conservacion) REFERENCES estado_conservacion(id_estado_conservacion)
);

-- 10. CLIENTE
CREATE TABLE cliente (
    nroDocCli VARCHAR(20) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    FK_id_tipo_documento INT NOT NULL,
    FOREIGN KEY (FK_id_tipo_documento) REFERENCES tipo_documento(id_tipo_documento)
);

-- 11. DIRECCION_CLIENTE
CREATE TABLE direccion_cliente (
    id_direccion INT PRIMARY KEY IDENTITY(1,1),
    FK_nroDocCli VARCHAR(20) NOT NULL,
    direccion NVARCHAR(200),
    ciudad NVARCHAR(100),
    FOREIGN KEY (FK_nroDocCli) REFERENCES cliente(nroDocCli)
);

-- 12. TELEFONO_CLIENTE
CREATE TABLE telefono_cliente (
    id_telefono INT PRIMARY KEY IDENTITY(1,1),
    FK_nroDocCli VARCHAR(20) NOT NULL,
    telefono VARCHAR(20),
    FOREIGN KEY (FK_nroDocCli) REFERENCES cliente(nroDocCli)
);

-- 13. AVAL
CREATE TABLE aval (
    id_aval VARCHAR(20) PRIMARY KEY,
    FK_nroDocCli VARCHAR(20) NOT NULL, -- El cliente que avala
    nombreAval VARCHAR(100) NOT NULL,
    FOREIGN KEY (FK_nroDocCli) REFERENCES cliente(nroDocCli)
);

-- 14. USUARIO_SISTEMA
CREATE TABLE usuario_sistema (
    id_usuario INT PRIMARY KEY IDENTITY(1,1),
    nombre_usuario NVARCHAR(50) NOT NULL,
    clave NVARCHAR(50) NOT NULL,
    contraseña NVARCHAR(100) NOT NULL
);

-- 15. EMPLEADO
CREATE TABLE empleado (
    id_empleado INT PRIMARY KEY IDENTITY(1,1),
    FK_id_tipo_documento INT NOT NULL,
    numero_documento VARCHAR(20) NOT NULL UNIQUE,
    nombre NVARCHAR(100) NOT NULL,
    FK_id_cargo INT NOT NULL,
    fecha_ingreso DATE,
    FOREIGN KEY (FK_id_tipo_documento) REFERENCES tipo_documento(id_tipo_documento),
    FOREIGN KEY (FK_id_cargo) REFERENCES cargo(id_cargo)
);

-- 16. ALQUILER
CREATE TABLE alquiler (
    id_alquiler INT PRIMARY KEY IDENTITY(1,1),
    FK_nroDocCli VARCHAR(20) NOT NULL,
    FK_id_ejemplar INT NOT NULL,
	FK_id_usuario INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    dias_alquiler INT NOT NULL,
    fecha_devolucion DATE,
    FOREIGN KEY (FK_nroDocCli) REFERENCES cliente(nroDocCli),
    FOREIGN KEY (FK_id_ejemplar) REFERENCES ejemplar(id_ejemplar),
    FOREIGN KEY (FK_id_usuario) REFERENCES usuario_sistema(id_usuario)
);

COMMIT;
PRINT 'Base de datos y tablas creadas con éxito.';

END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Error en la creación, transacción revertida.';
END CATCH;
