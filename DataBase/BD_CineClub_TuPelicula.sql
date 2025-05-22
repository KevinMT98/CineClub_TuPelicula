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

-- 15. EMPLEADO
CREATE TABLE empleado (
    id_empleado INT PRIMARY KEY IDENTITY(1,1),
    FK_id_tipo_documento INT NOT NULL,
	FK_id_empleado INT,
    numero_documento VARCHAR(20) NOT NULL UNIQUE,
    nombre NVARCHAR(100) NOT NULL,
	apellido1 NVARCHAR(100),
	apellido2 NVARCHAR(100),
	activo BIT DEFAULT 0,
    FK_id_cargo INT NOT NULL,
    fecha_ingreso DATE,
    FOREIGN KEY (FK_id_tipo_documento) REFERENCES tipo_documento(id_tipo_documento),
    FOREIGN KEY (FK_id_cargo) REFERENCES cargo(id_cargo),
	FOREIGN KEY (FK_id_empleado) REFERENCES empleado(id_empleado)
);

-- 3. ESTADO_CONSERVACION
CREATE TABLE estado_conservacion (
    id_estado_conservacion INT PRIMARY KEY IDENTITY(1,1),
    descripcion NVARCHAR(100) NOT NULL,
	activo BIT DEFAULT 0
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
	FK_id_empleado INT,
    nombre NVARCHAR(100) NOT NULL,
	activo BIT DEFAULT 0,
    FK_id_nacionalidad INT,
    FOREIGN KEY (FK_id_nacionalidad) REFERENCES nacionalidad(id_nacionalidad),
	FOREIGN KEY (FK_id_empleado) REFERENCES empleado(id_empleado)
);

-- 6. PELICULA
CREATE TABLE pelicula (
    id_pelicula INT PRIMARY KEY IDENTITY(1,1),
	FK_id_empleado INT,
	FK_id_nacionalidad INT,
	FK_id_director INT NOT NULL,
    titulo NVARCHAR(200) NOT NULL,
    productora NVARCHAR(100),
    fecha_estreno DATE,
	activo BIT DEFAULT 0,    
    FOREIGN KEY (FK_id_nacionalidad) REFERENCES nacionalidad(id_nacionalidad),
    FOREIGN KEY (FK_id_director) REFERENCES director(id_director),
	FOREIGN KEY (FK_id_empleado) REFERENCES empleado(id_empleado)
);
-- GENERO
CREATE TABLE genero (
	id_genero INT PRIMARY KEY,
	nom_genero NVARCHAR(100),
	activo BIT DEFAULT 0,
);

-- 7. ACTOR
CREATE TABLE actor (
    id_actor INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    FK_id_nacionalidad INT,
	FK_id_genero INT,
    sexo CHAR(1) CHECK (sexo IN ('M', 'F')),
	activo BIT DEFAULT 0,
    FOREIGN KEY (FK_id_nacionalidad) REFERENCES nacionalidad(id_nacionalidad),
    FOREIGN KEY (FK_id_genero) REFERENCES genero(id_genero),
);

-- PAPEL 
CREATE TABLE papel (
	id_papel INT PRIMARY KEY,
	nom_papel NVARCHAR(100),
);

-- 8. PELICULA_ACTOR
CREATE TABLE pelicula_actor (
	id_pelicula_actor INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    FK_id_pelicula INT,
    FK_id_actor INT,
    nombre_per NVARCHAR(100),
	avtivo BIT DEFAULT 0,
    FOREIGN KEY (FK_id_pelicula) REFERENCES pelicula(id_pelicula),
    FOREIGN KEY (FK_id_actor) REFERENCES actor(id_actor)
);

-- 9. EJEMPLAR
CREATE TABLE ejemplar (
    id_ejemplar INT PRIMARY KEY IDENTITY(1,1),
    FK_id_pelicula INT NOT NULL,
	FK_id_empleado INT,
    numero_ejemplar INT NOT NULL,
	activo BIT DEFAULT 0,
    FK_id_estado_conservacion INT,
    FOREIGN KEY (FK_id_pelicula) REFERENCES pelicula(id_pelicula),
    FOREIGN KEY (FK_id_estado_conservacion) REFERENCES estado_conservacion(id_estado_conservacion),
	FOREIGN KEY (FK_id_empleado) REFERENCES empleado(id_empleado)
);

-- 10. CLIENTE
CREATE TABLE cliente (
	id_cliente INT PRIMARY KEY,
    nroDocCli VARCHAR(20) NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    FK_id_tipo_documento INT NOT NULL,
	FK_id_cliente INT,
    FOREIGN KEY (FK_id_tipo_documento) REFERENCES tipo_documento(id_tipo_documento),
    FOREIGN KEY (FK_id_cliente) REFERENCES cliente(id_cliente),
);

-- CIUDAD

CREATE TABLE ciudad (
	id_ciudad INT PRIMARY KEY IDENTITY(1,1),
	nom_ciudad NVARCHAR(100),
	cod_postal NVARCHAR(100),
);

-- 11. DIRECCION_CLIENTE
CREATE TABLE direccion_cliente (
    id_direccion INT PRIMARY KEY IDENTITY(1,1),
    FK_id_cliente INT,
    FK_id_ciudad INT,
    direccion NVARCHAR(200),
    ciudad NVARCHAR(100),
    FOREIGN KEY (FK_id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (FK_id_ciudad) REFERENCES ciudad(id_ciudad),
);
-- TIPO DE CELULAR
CREATE TABLE tipo_telefono (
	id_tip_telefono INT PRIMARY KEY,
	nom_tip_telefono NVARCHAR(100),
);

-- 12. TELEFONO_CLIENTE
CREATE TABLE telefono_cliente (
    id_telefono INT PRIMARY KEY IDENTITY(1,1),
    FK_id_cliente INT,
	FK_id_tip_telefono INT,
    telefono VARCHAR(20),
    FOREIGN KEY (FK_id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (FK_id_tip_telefono) REFERENCES tipo_telefono(id_tip_telefono),
);

-- 14. USUARIO_SISTEMA
CREATE TABLE usuario_sistema (
    id_usuario INT PRIMARY KEY IDENTITY(1,1),
	FK_id_empleado INT,
    nombre_usuario NVARCHAR(50) NOT NULL,
    contraseña NVARCHAR(100) NOT NULL,
	FOREIGN KEY (FK_id_empleado) REFERENCES empleado(id_empleado)
);



-- 16. ALQUILER
CREATE TABLE alquiler (
    id_alquiler INT PRIMARY KEY IDENTITY(1,1),
    FK_id_cliente INT,
    FK_id_ejemplar INT,
	FK_id_empleado INT,
    fecha_inicio DATE NOT NULL,
    dias_alquiler INT NOT NULL,
    fecha_devolucion DATE,
    FOREIGN KEY (FK_id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (FK_id_ejemplar) REFERENCES ejemplar(id_ejemplar),
	FOREIGN KEY (FK_id_empleado) REFERENCES empleado(id_empleado)
);

COMMIT;
PRINT 'Base de datos y tablas creadas con éxito.';

END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Error en la creación, transacción revertida.';
END CATCH;
