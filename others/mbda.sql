
1. 
a.
SELECT * FROM mbda.miembros;

b.
INSERT INTO mbda.miembros VALUES (327,1,1015484152,'nico@gmail.com','Male','Colombia',null,null,1,1,null,null);
INSERT INTO mbda.miembros VALUES (326,1,2153478,'santi@gmail.com','Male','Mexico',null,null,1,1,null,null);


c. 
DELETE FROM mbda.miembros WHERE (miembros.numero = 327);

NO lo permite pues dice que no se tienen los privilegios suficientes para realizar la accion 

d.
GRANT 
    UPDATE,DELETE ON mbda.miembros TO PUBLIC;
    
e.
--Archivo
--Data Modeler
--Importar 
--Diccionario de Datos
--Seleccionar conexion 
--Seleccione el esquema/base de datos que desea importar 
--Seleccione los obketos que desea importar 
--Ver el resumen y generar el diseño de Oracle SQL Developer Data Modeler.


--MODELO FISICO--

CREATE OR REPLACE PACKAGE PC_EVALUACION IS
	PROCEDURE AD_EVALUACION(xpuntaje IN NUMBER,xcomentarios IN VARCHAR,xrecomendaciones IN VARCHAR);
	PROCEDURE AD_SIMILARA(xporcentaje IN NUMBER);
	PROCEDURE MO_PUNTAJE_EVALUACION(xpuntaje);
	PROCEDURE MO_COMENTARIOS_EVALUACION(xcomentario);
	FUNCTION CO_EVALUACIONES(xevaluacionID IN VARCHAR) RETURN SYS_REFCURSOR;
	FUNCTION CO_ATLETAS_CALIFICACION(xpuntaje) RETURN SYS_REFCURSOR;
END PC_EVALUACION;
