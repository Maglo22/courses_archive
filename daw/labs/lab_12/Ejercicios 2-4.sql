-- Ejercicio 2 --
--INSERT INTO Materiales values(1000, 'xxx', 1000)
--DELETE FROM Materiales WHERE Clave = 1000 AND Costo = 1000

--ALTER TABLE Materiales add constraint llaveMateriales PRIMARY KEY(Clave)
--INSERT INTO Materiales values(1000, 'xxx', 1000)

--ALTER TABLE Proveedores add constraint llaveProveedores PRIMARY KEY(RFC)
--ALTER TABLE Proyectos add constraint llaveProyectos PRIMARY KEY(Numero)
--ALTER TABLE Entregan add constraint llaveEntregan PRIMARY KEY(Clave, RFC, Numero, Fecha)

-- Ejercicio 3 --
--INSERT INTO Entregan values(0, 'xxx', 0, '1-jan-02', 0)
--DELETE from Entregan WHERE Clave = 0

--ALTER TABLE Entregan add constraint cfentreganclave
--foreign key (Clave) references Materiales(Clave)
--INSERT INTO Entregan values(0, 'xxx', 0, '1-jan-02', 0)

--ALTER TABLE Entregan add constraint cfentreganrfc
--foreign key (RFC) references Proveedores(RFC)

--ALTER TABLE Entregan add constraint cfentregannumero
--foreign key (Numero) references Proyectos(Numero)

-- Ejercicio 4 --
--INSERT INTO Entregan values (1000, 'AAAA800101', 5000, GETDATE(), 0)
--DELETE from Entregan WHERE Cantidad = 0
--ALTER TABLE Entregan add constraint Cantidad check (Cantidad > 0)
--INSERT INTO Entregan values (1000, 'AAAA800101', 5000, GETDATE(), 0)