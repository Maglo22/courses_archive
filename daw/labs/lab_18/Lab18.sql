-- Laboratorio 18 --
--SET DATEFORMAT dmy
--SELECT E.Cantidad, SUM((M.Costo * E.Cantidad) + (M.PorcentajeImpuesto/100)) as Total
--FROM Entregan E, Materiales M
--WHERE M.Clave = E.Clave AND E.Fecha between '01/01/97' AND '31/12/97'
--GROUP BY E.Cantidad

--SELECT RazonSocial, COUNT(E.RFC) as 'Número de Entregas', SUM((M.Costo * E.Cantidad) + (M.PorcentajeImpuesto/100)) as Total
--FROM Proveedores Pr, Entregan E, Materiales M
--WHERE Pr.RFC = E.RFC AND E.Clave = M.Clave
--GROUP BY RazonSocial

--SELECT E.Clave, M.Descripcion, SUM(E.Cantidad) as 'Cantidad Total', MIN(E.Cantidad) as 'Cantidad mínima entregada', MAX(E.Cantidad) as 'Cantidad máxima entregada', SUM((M.Costo * E.Cantidad) + (M.PorcentajeImpuesto/100)) as 'Importe total'
--FROM Materiales M, Entregan E
--WHERE M.Clave = E.Clave
--GROUP BY E.Clave, M.Descripcion
--HAVING AVG(E.Cantidad) > 400

--SELECT Pr.RazonSocial, AVG(E.Cantidad) as 'Cantidad Promedio', M.Clave, M.Descripcion
--FROM Proveedores Pr, Entregan E, Materiales M
--WHERE Pr.RFC = E.RFC AND M.Clave = E.Clave
--GROUP BY Pr.RazonSocial, M.Clave, M.Descripcion
--HAVING AVG(E.Cantidad) >= 500

--SELECT Pr.RazonSocial, AVG(E.Cantidad) as 'Cantidad Promedio', M.Clave, M.Descripcion
--FROM Proveedores Pr, Entregan E, Materiales M
--WHERE Pr.RFC = E.RFC AND M.Clave = E.Clave
--GROUP BY Pr.RazonSocial, M.Clave, M.Descripcion
--HAVING AVG(E.Cantidad) < 370 OR AVG(E.Cantidad) > 450

--INSERT INTO Materiales VALUES (1440, 'Barras de Hierro', 25, 2.8)
--INSERT INTO Materiales VALUES (1450, 'Barras de Uranio', 70, 2.9)
--INSERT INTO Materiales VALUES (1460, 'Cubos de Tierra', 10, 2.9)
--INSERT INTO Materiales VALUES (1470, 'Cubos de Arena', 10, 2.9)
--INSERT INTO Materiales VALUES (1480, 'Cubos de Diamante', 70, 2.9)

--SELECT DISTINCT Clave, Descripcion
--FROM Materiales
--WHERE Clave NOT IN (
--	SELECT DISTINCT M.Clave
--	FROM Materiales M, Entregan E
--	WHERE M.Clave = E.Clave )

--SELECT DISTINCT RazonSocial
--FROM Proveedores Pr, Proyectos P, Entregan E
--WHERE Pr.RFC = E.RFC AND P.Numero = E.Numero AND Denominacion LIKE 'Vamos Mexico' AND RazonSocial IN(
--	SELECT RazonSocial
--	FROM Proveedores Pr, Proyectos P, Entregan E
--	WHERE Pr.RFC = E.RFC AND P.Numero = E.Numero AND Denominacion LIKE 'Queretaro Limpio')

--SELECT Descripcion
--FROM Materiales M, Entregan E
--WHERE M.Clave = E.Clave AND E.Numero NOT IN (SELECT E.Numero
--											FROM Entregan E, Proyectos P
--											WHERE E.Numero = P.Numero AND P.Denominacion LIKE 'CIT Yucatan')

--SELECT RazonSocial, AVG(E.Cantidad) as 'Cantidad promedio'
--FROM Proveedores Pr, Entregan E
--WHERE Pr.RFC = E.RFC
--GROUP BY RazonSocial
--HAVING AVG(E.Cantidad) > (SELECT AVG(E.Cantidad)
--							FROM Proveedores Pr
--							WHERE Pr.RFC = 'VAGO780901')

--SELECT E.RFC, RazonSocial
--FROM Proveedores Pr, Entregan E, Proyectos P
--WHERE Pr.RFC = E.RFC AND E.Numero = P.Numero AND P.Denominacion LIKE 'Infonavit Durango' AND E.Fecha between '01/01/01' AND '31/12/01'
--GROUP BY E.RFC, RazonSocial, E.Fecha
--HAVING SUM(E.Cantidad) > ( SELECT SUM(E.Cantidad)
--							FROM Proveedores Pr, Entregan E, Proyectos P
--							WHERE Pr.RFC = E.RFC AND P.Numero = E.Numero AND P.Denominacion LIKE 'Infonavit Durango' AND E.Fecha between '01/01/00' AND '31/12/00' )
