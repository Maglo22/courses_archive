-- Laboratorio 23 --
/*
-- Crear Tablas --
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Clientes_Banca')
DROP TABLE Clientes_Banca

CREATE TABLE Clientes_Banca
(
	NoCuenta varchar(5) not null PRIMARY KEY,
	Nombre varchar(30),
	Saldo numeric(10,2)
)

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Tipos_Movimiento')
DROP TABLE Tipos_Movimiento

CREATE TABLE Tipos_Movimiento
(
	ClaveM varchar(2) not null PRIMARY KEY,
	Descripcion varchar(30)
)

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='Realizan')
DROP TABLE Realizan

CREATE TABLE Realizan
(
	NoCuenta varchar(5) not null FOREIGN KEY REFERENCES Clientes_Banca(NoCuenta),
	ClaveM varchar(2) not null FOREIGN KEY REFERENCES Tipos_Movimiento(ClaveM),
	Fecha datetime,
	Monto varchar(50)
)

-- Transacciones --

BEGIN TRANSACTION PRUEBA1
INSERT INTO CLIENTES_BANCA VALUES('001', 'Manuel Rios Maldonado', 9000);
INSERT INTO CLIENTES_BANCA VALUES('002', 'Pablo Perez Ortiz', 5000);
INSERT INTO CLIENTES_BANCA VALUES('003', 'Luis Flores Alvarado', 8000);
COMMIT TRANSACTION PRUEBA1 

SELECT * FROM Clientes_Banca

BEGIN TRANSACTION PRUEBA2
INSERT INTO CLIENTES_BANCA VALUES('004','Ricardo Rios Maldonado',19000); 
INSERT INTO CLIENTES_BANCA VALUES('005','Pablo Ortiz Arana',15000); 
INSERT INTO CLIENTES_BANCA VALUES('006','Luis Manuel Alvarado',18000);

SELECT * FROM Clientes_Banca

ROLLBACK TRANSACTION PRUEBA2

BEGIN TRANSACTION PRUEBA3
INSERT INTO TIPOS_MOVIMIENTO VALUES('A','Retiro Cajero Automatico');
INSERT INTO TIPOS_MOVIMIENTO VALUES('B','Deposito Ventanilla');
COMMIT TRANSACTION PRUEBA3

BEGIN TRANSACTION PRUEBA4
INSERT INTO REALIZAN VALUES('001','A',GETDATE(),500);
UPDATE CLIENTES_BANCA SET SALDO = SALDO -500
WHERE NoCuenta='001'
COMMIT TRANSACTION PRUEBA4

SELECT * FROM Realizan

BEGIN TRANSACTION PRUEBA5
INSERT INTO CLIENTES_BANCA VALUES('005','Rosa Ruiz Maldonado',9000);
INSERT INTO CLIENTES_BANCA VALUES('006','Luis Camino Ortiz',5000);
INSERT INTO CLIENTES_BANCA VALUES('001','Oscar Perez Alvarado',8000);

IF @@ERROR = 0
COMMIT TRANSACTION PRUEBA5
ELSE
BEGIN
PRINT 'A transaction needs to be rolled back'
ROLLBACK TRANSACTION PRUEBA5
END

SELECT * FROM Clientes_Banca


IF EXISTS (SELECT name FROM sysobjects 
                       WHERE name = 'REGISTRAR_RETIRO_CAJERO' AND type = 'P')
                DROP PROCEDURE REGISTRAR_RETIRO_CAJERO
            GO
            
            CREATE PROCEDURE REGISTRAR_RETIRO_CAJERO
                @noCuenta VARCHAR(5),
                @monto NUMERIC(10,2)
            AS
				BEGIN TRANSACTION Retiro
				UPDATE Clientes_Banca SET Saldo = Saldo - @monto WHERE NoCuenta = @noCuenta
				INSERT INTO Realizan VALUES(@noCuenta, 'A', GETDATE(), @monto)

				IF @@ERROR = 0
				COMMIT TRANSACTION Retiro
				ELSE
				BEGIN
				PRINT 'Error en la transacción'
				ROLLBACK TRANSACTION Retiro
				END
			GO

IF EXISTS (SELECT name FROM sysobjects 
                       WHERE name = 'REGISTRAR_DEPOSITO_VENTANILLA' AND type = 'P')
                DROP PROCEDURE REGISTRAR_DEPOSITO_VENTANILLA
            GO
            
            CREATE PROCEDURE REGISTRAR_DEPOSITO_VENTANILLA
                @noCuenta VARCHAR(5),
                @monto NUMERIC(10,2)
            AS
				BEGIN TRANSACTION Deposito
				UPDATE Clientes_Banca SET Saldo = Saldo + @monto WHERE NoCuenta = @noCuenta
				INSERT INTO Realizan VALUES(@noCuenta, 'B', GETDATE(), @monto)

				IF @@ERROR = 0
				COMMIT TRANSACTION Deposito
				ELSE
				BEGIN
				PRINT 'Error en la transacción'
				ROLLBACK TRANSACTION Deposito
				END
			GO
*/