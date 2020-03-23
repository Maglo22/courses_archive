IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Materiales')
DROP TABLE Materiales

CREATE TABLE Materiales
(
	Clave numeric(5) not null,
	Descripcion varchar(50),
	Costo numeric(8,2)
)

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Proveedores')
DROP TABLE Proveedores

CREATE TABLE Proveedores
(
	RFC char(13) not null,
	RazonSocial varchar(50)
)

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Proyectos')
DROP TABLE Proyectos

CREATE TABLE Proyectos
(
	Numero numeric(5) not null,
	Denominacion varchar(50)
)

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Entregan')
DROP TABLE Entregan

CREATE TABLE Entregan
(
	Clave numeric(5) not null,
	RFC char(13) not null,
	Numero numeric(5) not null,
	Fecha DateTime not null,
	Cantidad numeric(8,2)
)

BULK INSERT a1700879.a1700879.[Materiales]
FROM 'e:\wwwroot\a1700879\materiales.csv'
WITH
(
	CODEPAGE='ACP',
	FIELDTERMINATOR=',',
	ROWTERMINATOR='\n'
)

BULK INSERT a1700879.a1700879.[Proyectos]
FROM 'e:\wwwroot\a1700879\proyectos.csv'
WITH
(
	CODEPAGE='ACP',
	FIELDTERMINATOR=',',
	ROWTERMINATOR='\n'
)

BULK INSERT a1700879.a1700879.[Proveedores]
FROM 'e:\wwwroot\a1700879\proveedores.csv'
WITH
(
	CODEPAGE='ACP',
	FIELDTERMINATOR=',',
	ROWTERMINATOR='\n'
)

SET DATEFORMAT dmy
BULK INSERT a1700879.a1700879.[Entregan]
FROM 'e:\wwwroot\a1700879\entregan.csv'
WITH
(
	CODEPAGE='ACP',
	FIELDTERMINATOR=',',
	ROWTERMINATOR='\n'
)