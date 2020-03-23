--set DATEFORMAT dmy
--SELECT * FROM Materiales

--SELECT * FROM Materiales WHERE Clave=1000

--SELECT * FROM Materiales, Entregan WHERE Materiales.Clave = Entregan.Clave

--SELECT Clave, RFC, Fecha FROM Entregan

--SELECT * FROM Entregan WHERE Clave = 1450
--UNION
--SELECT * FROM Entregan WHERE Clave = 1300

--SELECT * FROM Entregan WHERE Clave = 1300 OR Clave = 1450

--SELECT Clave FROM Entregan WHERE Numero = 5001
--INTERSECT
--SELECT Clave FROM Entregan WHERE Numero = 5018

--SELECT * FROM Entregan
--EXCEPT
--SELECT * FROM Entregan WHERE Clave = 1000

--SELECT * FROM Entregan, Materiales

--SELECT DISTINCT Materiales.Descripcion FROM Materiales, Entregan WHERE Materiales.Clave = Entregan.Clave AND Entregan.Fecha between '01/01/00' AND '31/12/00'

--SELECT E.Numero, Denominacion, E.Fecha, Cantidad FROM Proyectos P, Entregan E WHERE P.Numero = E.Numero ORDER BY Numero, Fecha

--SELECT * FROM Materiales WHERE Descripcion LIKE 'Si%'

--SELECT * FROM Materiales WHERE Descripcion LIKE 'Si'

--DECLARE @foo varchar(40);
--DECLARE @bar varchar(40);
--SET @foo = '¿Que resultado';
--SET @bar = ' ¿¿¿???';
--SET @foo += ' obtienes?';
--PRINT @foo + @bar;

--SELECT RFC FROM Entregan WHERE RFC LIKE '[A-D]%'
--SELECT RFC FROM Entregan WHERE RFC LIKE '[^A]%'
--SELECT Numero FROM Entregan WHERE Numero LIKE '___6'

--SELECT Clave, RFC, Numero, Fecha, Cantidad FROM Entregan WHERE Numero Between 5000 AND 5010

--SELECT RFC,Cantidad, Fecha,Numero 
--FROM [Entregan] 
--WHERE [Numero] Between 5000 and 5010 AND 
--Exists ( SELECT [RFC] 
--FROM [Proveedores] 
--WHERE RazonSocial LIKE 'La%' and [Entregan].[RFC] = [Proveedores].[RFC] )

--SELECT RFC,Cantidad, Fecha,Numero 
--FROM [Entregan] 
--WHERE [Numero] Between 5000 and 5010 AND RFC
--IN ( SELECT [RFC] 
--FROM [Proveedores] 
--WHERE RazonSocial LIKE 'La%' and [Entregan].[RFC] = [Proveedores].[RFC] )

--SELECT RFC,Cantidad, Fecha,Numero 
--FROM [Entregan] 
--WHERE [Numero] Between 5000 and 5010 AND RFC
--NOT IN ( SELECT [RFC] 
--FROM [Proveedores] 
--WHERE RazonSocial NOT LIKE 'La%' and [Entregan].[RFC] = [Proveedores].[RFC] )

--SELECT TOP 2 * FROM Proyectos

--SELECT TOP Numero FROM Proyectos

--ALTER TABLE materiales ADD PorcentajeImpuesto NUMERIC(6,2);
--UPDATE materiales SET PorcentajeImpuesto = 2*clave/1000;

--CREATE VIEW Uni (Clave, RFC, Numero, Fecha, Cantidad) as
--SELECT * FROM Entregan WHERE Clave = 1450
--UNION
--SELECT * FROM Entregan WHERE Clave = 1300
--SELECT * FROM Uni

--CREATE VIEW Inter (Clave) as
--SELECT Clave FROM Entregan WHERE Numero = 5001
--INTERSECT
--SELECT Clave FROM Entregan WHERE Numero = 5018
--SELECT * FROM Inter

--CREATE VIEW Minus (Clave, RFC, Numero, Fecha, Cantidad) as
--SELECT * FROM Entregan
--EXCEPT
--SELECT * FROM Entregan WHERE Clave = 1000
--SELECT * FROM Minus

--CREATE VIEW Si as
--SELECT * FROM Materiales WHERE Descripcion LIKE 'Si%'
--SELECT * FROM Si

--CREATE VIEW num6 as
--SELECT Numero FROM Entregan WHERE Numero LIKE '___6'
--SELECT * FROM num6

--SELECT E.Clave, Descripcion
--FROM Materiales M, Entregan E, Proyectos Pr
--WHERE M.Clave = E.Clave AND Pr.Numero = E.Numero AND Pr.Denominacion LIKE 'Mexico sin ti no estamos completos'

--SELECT E.Clave, Descripcion
--FROM Materiales M, Entregan E, Proveedores Pr
--WHERE M.Clave = E.Clave AND Pr.RFC = E.RFC AND Pr.RazonSocial LIKE 'Acme tools'

--SELECT P.RFC, AVG(Cantidad) as Promedio
--FROM Proveedores P, Entregan E
--WHERE P.RFC = E.RFC AND E.Fecha BETWEEN '01/01/00' AND '31/12/00'
--GROUP BY P.RFC
--HAVING AVG(Cantidad) >= 300

--SELECT M.Descripcion, SUM(E.Cantidad) as Total
--FROM Materiales M, Entregan E
--WHERE M.Clave = E.Clave AND E.Fecha BETWEEN '01/01/00' AND '31/12/00'
--GROUP BY M.Descripcion

--CREATE VIEW Mat01 (Clave, Total) as
--SELECT M.Clave, SUM(E.Cantidad) as Total
--FROM Materiales M, Entregan E
--WHERE M.Clave = E.Clave AND E.Fecha Between '01/01/01' AND '31/12/01'
--GROUP BY M.Clave
--SELECT TOP 1* FROM Mat01

--SELECT Descripcion
--FROM Materiales
--WHERE Descripcion LIKE '%ub%'

--SELECT Denominacion, SUM(M.Costo) as Total
--FROM Proyectos P, Materiales M, Entregan E
--WHERE P.Numero = E.Numero AND M.Clave = E.Clave
--GROUP BY Denominacion

--CREATE VIEW Televisa (Denominacion, RFC, RazonSocial) as
--SELECT DISTINCT Denominacion, P.RFC, RazonSocial
--FROM Proveedores P, Proyectos Pr, Entregan E
--WHERE P.RFC = E.RFC AND Pr.Numero = E.Numero AND Denominacion LIKE 'Televisa%'
--CREATE VIEW Coahuila (Denominacion, RFC, RazonSocial) as
--SELECT DISTINCT Denominacion, P.RFC, RazonSocial
--FROM Proveedores P, Proyectos Pr, Entregan E
--WHERE P.RFC = E.RFC AND Pr.Numero = E.Numero AND Denominacion LIKE '%Coahuila%'
--CREATE VIEW Diff as
--SELECT RazonSocial FROM Televisa
--EXCEPT
--SELECT RazonSocial FROM Coahuila
--SELECT * FROM Televisa WHERE RazonSocial IN (SELECT * FROM Diff)

--SELECT DISTINCT Denominacion, P.RFC, RazonSocial
--FROM Proveedores P, Proyectos Pr, Entregan E
--WHERE P.RFC = E.RFC AND Pr.Numero = E.Numero AND Denominacion LIKE 'Televisa%'
--AND RazonSocial NOT IN (
--	SELECT DISTINCT RazonSocial
--	FROM Proveedores P, Proyectos Pr, Entregan E
--	WHERE P.RFC = E.RFC AND Pr.Numero = E.Numero AND Denominacion LIKE '%Coahuila%'
--)

--SELECT DISTINCT Descripcion, Costo
--FROM Materiales M, Entregan E, Televisa T, Coahuila C
--WHERE M.Clave = E.Clave AND E.RFC IN (T.RFC) AND E.RFC IN (C.RFC)

--SELECT Descripcion, Cantidad, SUM(Costo) as Total
--FROM Materiales M, Entregan E
--WHERE M.Clave = E.Clave
--GROUP BY Descripcion, Cantidad
