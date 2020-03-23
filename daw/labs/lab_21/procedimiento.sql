DROP PROCEDURE IF EXISTS crearEmpleado;
DELIMITER //
CREATE PROCEDURE crearEmpleado(IN nom VARCHAR(50), IN r VARCHAR(50), IN dep VARCHAR(50))
BEGIN
	DECLARE nombre VARCHAR(50) DEFAULT 'nombre';
	DECLARE rol VARCHAR(50) DEFAULT 'rol';
	DECLARE departamento VARCHAR(50) DEFAULT 'departamento';
	SET nombre = nom;
	SET rol = r;
	SET departamento = dep;
    INSERT INTO usuarios (nombre, rol, departamento) VALUES(nombre, rol, departamento);
END //
DELIMITER ;