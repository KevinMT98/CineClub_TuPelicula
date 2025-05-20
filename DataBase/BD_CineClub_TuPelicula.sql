CREATE DATABASE BD_CineClub_TuPelicula;

GO
USE [BD_CineClub_TuPelicula]
GO

BEGIN TRANSACTION;
BEGIN TRY

-- 1. DIRECTOR
CREATE TABLE DIRECTOR (
    id_director INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    nacionalidad NVARCHAR(50)
);

-- 2. PELICULA
CREATE TABLE PELICULA (
    id_pelicula INT PRIMARY KEY IDENTITY(1,1),
    titulo NVARCHAR(200) NOT NULL,
    nacionalidad NVARCHAR(50),
    productora NVARCHAR(100),
    fecha_estreno DATE,
    FK_id_director INT NOT NULL,
    FOREIGN KEY (FK_id_director) REFERENCES DIRECTOR(id_director)
);

-- 3. ACTOR
CREATE TABLE ACTOR (
    id_actor INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    nacionalidad NVARCHAR(50),
    sexo CHAR(1) CHECK (sexo IN ('M', 'F'))
);

-- 4. PELICULA_ACTOR
CREATE TABLE PELICULA_ACTOR (
	id_pelicula_actor INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    FK_id_pelicula INT,
    FK_id_actor INT,
    es_principal BIT DEFAULT 0,
    FOREIGN KEY (FK_id_pelicula) REFERENCES PELICULA(id_pelicula),
    FOREIGN KEY (FK_id_actor) REFERENCES ACTOR(id_actor)
);

-- 5. EJEMPLAR
CREATE TABLE EJEMPLAR (
    id_ejemplar INT PRIMARY KEY IDENTITY(1,1),
    FK_id_pelicula INT NOT NULL,
    numero_ejemplar INT NOT NULL,
    estado_conservacion NVARCHAR(100),
    FOREIGN KEY (FK_id_pelicula) REFERENCES PELICULA(id_pelicula)
);

-- 6. CLIENTE
CREATE TABLE CLIENTE (
    nroDocCli VARCHAR(20) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL
);

-- 7. DIRECCION_CLIENTE
CREATE TABLE DIRECCION_CLIENTE (
    id_direccion INT PRIMARY KEY IDENTITY(1,1),
    FK_nroDocCli VARCHAR(20) NOT NULL,
    direccion NVARCHAR(200),
    ciudad NVARCHAR(100),
    FOREIGN KEY (FK_nroDocCli) REFERENCES CLIENTE(nroDocCli)
);

-- 8. TELEFONO_CLIENTE
CREATE TABLE TELEFONO_CLIENTE (
    id_telefono INT PRIMARY KEY IDENTITY(1,1),
    FK_nroDocCli VARCHAR(20) NOT NULL,
    telefono VARCHAR(20),
    FOREIGN KEY (FK_nroDocCli) REFERENCES CLIENTE(nroDocCli)
);

-- 9. AVAL
CREATE TABLE AVAL (
    id_aval VARCHAR(20) PRIMARY KEY, -- 
    FK_nroDocCli VARCHAR(20) NOT NULL, -- El cliente que avala
	nombreAval VARCHAR(100) NOT NULL, -- Nombre Alvalador
    FOREIGN KEY (FK_nroDocCli) REFERENCES CLIENTE(nroDocCli),
);

-- 10. USUARIO_SISTEMA
CREATE TABLE USUARIO_SISTEMA (
    id_usuario INT PRIMARY KEY IDENTITY(1,1),
    nombre_usuario NVARCHAR(50) NOT NULL,
    clave NVARCHAR(50) NOT NULL,
    contraseña NVARCHAR(100) NOT NULL
);

-- 11. ALQUILER
CREATE TABLE ALQUILER (
    id_alquiler INT PRIMARY KEY IDENTITY(1,1),
    FK_nroDocCli VARCHAR(20) NOT NULL,
    FK_id_ejemplar INT NOT NULL,
	FK_id_usuario INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    dias_alquiler INT NOT NULL,
    fecha_devolucion DATE,
    FOREIGN KEY (FK_nroDocCli) REFERENCES CLIENTE(nroDocCli),
    FOREIGN KEY (FK_id_ejemplar) REFERENCES EJEMPLAR(id_ejemplar),
    FOREIGN KEY (FK_id_usuario) REFERENCES USUARIO_SISTEMA(id_usuario)
);

COMMIT;
    PRINT 'BD ha sido creada con exito';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Error en la creacion, transacción revertida';
END CATCH;

