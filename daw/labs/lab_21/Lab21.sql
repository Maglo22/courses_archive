--Materiales --
--IF EXISTS (SELECT name FROM sysobjects 
--                       WHERE name = 'creaMaterial' AND type = 'P')
--                DROP PROCEDURE creaMaterial
--            GO
            
--            CREATE PROCEDURE creaMaterial
--                @uclave NUMERIC(5,0),
--                @udescripcion VARCHAR(50),
--                @ucosto NUMERIC(8,2),
--                @uimpuesto NUMERIC(6,2)
--            AS
--                INSERT INTO Materiales VALUES(@uclave, @udescripcion, @ucosto, @uimpuesto)
--            GO

--EXECUTE creaMaterial 5000, 'Martillos Acme', 250, 15

--IF EXISTS (SELECT name FROM sysobjects 
--                       WHERE name = 'modificaMaterial' AND type = 'P')
--                DROP PROCEDURE modificaMaterial
--            GO
            
--            CREATE PROCEDURE modificaMaterial
--                @uclave NUMERIC(5,0),
--                @udescripcion VARCHAR(50),
--                @ucosto NUMERIC(8,2),
--                @uimpuesto NUMERIC(6,2)
--            AS
--                UPDATE Materiales SET Descripcion = @udescripcion, Costo = @ucosto, PorcentajeImpuesto = @uimpuesto
--				WHERE Clave = @uclave
--            GO

--EXECUTE modificaMaterial 5000, 'Clavos Acme', 200, 10

--IF EXISTS (SELECT name FROM sysobjects 
--                       WHERE name = 'eliminaMaterial' AND type = 'P')
--                DROP PROCEDURE eliminaMaterial
--            GO
            
--            CREATE PROCEDURE eliminaMaterial
--               @uclave NUMERIC(5,0)
--            AS
--                DELETE FROM Materiales WHERE Clave = @uclave
--            GO

--EXECUTE eliminaMaterial 5000

-- Proyectos --
--IF EXISTS (SELECT name FROM sysobjects 
--                       WHERE name = 'creaProyecto' AND type = 'P')
--                DROP PROCEDURE creaProyecto
--            GO
            
--            CREATE PROCEDURE creaProyecto
--                @unumero NUMERIC(5,0),
--                @udenominacion VARCHAR(50)
--            AS
--                INSERT INTO Proyectos VALUES(@unumero, @udenominacion)
--            GO

--EXECUTE creaProyecto 8000, 'CEPCQ'

--IF EXISTS (SELECT name FROM sysobjects 
--                       WHERE name = 'modificaProyecto' AND type = 'P')
--                DROP PROCEDURE modificaProyecto
--            GO
            
--            CREATE PROCEDURE modificaProyecto
--                @unumero NUMERIC(5,0),
--                @udenominacion VARCHAR(50)
--            AS
--                UPDATE Proyectos SET Denominacion = @udenominacion WHERE Numero = @unumero
--            GO

--EXECUTE modificaProyecto 8000, 'Protección Civil'

--IF EXISTS (SELECT name FROM sysobjects 
--                       WHERE name = 'eliminaProyecto' AND type = 'P')
--                DROP PROCEDURE eliminaProyecto
--            GO
            
--            CREATE PROCEDURE eliminaProyecto
--                @unumero NUMERIC(5,0)
--            AS
--                DELETE FROM Proyectos WHERE Numero = @unumero
--            GO

--EXECUTE eliminaProyecto 8000

-- Proveedores --
--IF EXISTS (SELECT name FROM sysobjects 
--                       WHERE name = 'creaProveedor' AND type = 'P')
--                DROP PROCEDURE creaProveedor
--            GO
            
--            CREATE PROCEDURE creaProveedor
--                @urfc CHAR(13),
--                @urazonSocial VARCHAR(50)
--            AS
--                INSERT INTO Proveedores VALUES(@urfc, @urazonSocial)
--            GO

--EXECUTE creaProveedor 'VAGO007698322', 'CEPCQ'

--IF EXISTS (SELECT name FROM sysobjects 
--                       WHERE name = 'modificaProveedor' AND type = 'P')
--                DROP PROCEDURE modificaProveedor
--            GO
            
--            CREATE PROCEDURE modificaProveedor
--                @urfc CHAR(13),
--                @urazonSocial VARCHAR(50)
--            AS
--                UPDATE Proveedores SET RazonSocial = @urazonSocial WHERE RFC = @urfc
--            GO

--EXECUTE modificaProveedor 'VAGO007698322', 'ESPN'

--IF EXISTS (SELECT name FROM sysobjects 
--                       WHERE name = 'meliminaProveedor' AND type = 'P')
--                DROP PROCEDURE eliminaProveedor
--            GO
            
--            CREATE PROCEDURE eliminaProveedor
--                @urfc CHAR(13)
--            AS
--                DELETE FROM Proveedores WHERE RFC = @urfc
--            GO

--EXECUTE eliminaProveedor 'VAGO007698322'

-- Entregan --
IF EXISTS (SELECT name FROM sysobjects 
                       WHERE name = 'creaEntrega' AND type = 'P')
                DROP PROCEDURE creaEntrega
            GO
            
            CREATE PROCEDURE creaEntrega
				@uclave NUMERIC(5,0),
                @urfc CHAR(13),
				@unumero NUMERIC(5,0),
				@ufecha DATETIME,
                @ucantidad NUMERIC(8,2)
            AS
                INSERT INTO Entregan VALUES(@uclave, @urfc, @unumero, @ufecha, @ucantidad)
            GO

IF EXISTS (SELECT name FROM sysobjects 
                       WHERE name = 'modificaEntrega' AND type = 'P')
                DROP PROCEDURE modificaEntrega
            GO
            
            CREATE PROCEDURE modificaEntrega
				@uclave NUMERIC(5,0),
                @urfc CHAR(13),
				@unumero NUMERIC(5,0),
				@ufecha DATETIME,
                @ucantidad NUMERIC(8,2)
            AS
                UPDATE Entregan SET Fecha = @ufecha, Cantidad = @ucantidad
				WHERE Clave = @uclave AND RFC = @urfc AND Numero = @unumero
            GO

IF EXISTS (SELECT name FROM sysobjects 
                       WHERE name = 'eliminaEntrega' AND type = 'P')
                DROP PROCEDURE eliminaEntrega
            GO
            
            CREATE PROCEDURE eliminaEntrega
				@uclave NUMERIC(5,0),
                @urfc CHAR(13),
				@unumero NUMERIC(5,0)
            AS
                DELETE FROM Entregan WHERE Clave = @uclave AND RFC = @urfc AND Numero = @unumero
            GO



-- Consultas --
IF EXISTS (SELECT name FROM sysobjects 
                                       WHERE name = 'queryMaterial' AND type = 'P')
                                DROP PROCEDURE queryMaterial
                            GO
                            
                            CREATE PROCEDURE queryMaterial
                                @udescripcion VARCHAR(50),
                                @ucosto NUMERIC(8,2)
                            
                            AS
                                SELECT * FROM Materiales WHERE descripcion 
                                LIKE '%'+@udescripcion+'%' AND costo > @ucosto 
                            GO

EXECUTE queryMaterial 'Lad',20