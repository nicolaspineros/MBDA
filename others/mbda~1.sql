
CREATE OR REPLACE PACKAGE PC_EVALUACION IS
	PROCEDURE AD_EVALUACION (xpuntaje IN NUMBER,xcomentarios IN VARCHAR,xrecomendaciones IN VARCHAR);
	PROCEDURE AD_SIMILARA (xporcentaje IN NUMBER);
	PROCEDURE MO_PUNTAJE_EVALUACION (xpuntaje IN NUMBER);
	PROCEDURE MO_COMENTARIOS_EVALUACION (xcomentario IN VARCHAR);
	FUNCTION CO_EVALUACIONES (xevaluacionID IN VARCHAR) RETURN SYS_REFCURSOR;
	FUNCTION CO_ATLETAS_CALIFICACION (xpuntaje IN NUMBER ,xnumero IN NUMBER) RETURN SYS_REFCURSOR;
	FUNCTION CO_EVALUACION_ENTRENADOR (xpuntaje IN NUMBER,xnumero IN NUMBER) RETURN SYS_REFCURSOR;
END PC_EVALUACION;

CREATE OR REPLACE PACKAGE BODY PC_EVALUACION IS

	PROCEDURE AD_EVALUACION (xpuntaje IN NUMBER,xcomentarios IN VARCHAR,xrecomendaciones IN VARCHAR) IS
		BEGIN
			INSERT INTO EVALUACION (puntaje,comentarios,recomendaciones) VALUES (xpuntaje,xcomentarios,xrecomendaciones);
		COMMIT;
		EXCEPTION
			WHEN OTHERS THEN
				ROLLBACK;
				RAISE_APPLICATION_ERROR('No se puede insertar evaluacion. ');
		END;
	PROCEDURE AD_SIMILARA (xporcentaje IN NUMBER) IS
		BEGIN
			INSERT INTO SIMILARA (porcentaje) VALUE (xporcentaje);
		COMMIT;
			WHEN OTHERS THEN
				ROLLBACK;
				RAISE_APPLICATION_ERROR('No se puede insertar similara. ');
		END;
	PROCEDURE MO_PUNTAJE_EVALUACION (xpuntaje IN NUMBER);
		BEGIN
			UPDATE EVALUACION SET puntaje = xpuntaje;
		COMMIT;
		EXCEPTION
			WHEN OTHERS THEN
					ROLLBACK;
					RAISE_APPLICATION_ERROR('Error al modificar evaluacion ');
		END;
	PROCEDURE MO_COMENTARIOS_EVALUACION (xcomentario IN VARCHAR);
		BEGIN
			UPDATE EVALUACION SET comentario = xcomentario;
		COMMIT;
		EXCEPTION
			WHEN OTHERS THEN
					ROLLBACK;
					RAISE_APPLICATION_ERROR('Error al modificar evaluacion ');
		END;
	FUNCTION CO_EVALUACIONES RETURN SYS_REFCURSOR IS CO_EV SYS_REFCURSOR;
		BEGIN
			OPEN CO_EV FOR
				SELECT * FROM EVALUACION;
			RETURN CO_EV;
		END;
	FUNCTION CO_ATLETAS_CALIFICACION(xpuntaje) RETURN SYS_REFCURSOR IS CO_AT_CA;
		BEGIN 
			OPEN CO_AT_CA FOR 
				SELECT puntaje FROM EVALUACION
				ORDER BY puntaje
			RETURN CO_AT_CA
		END;
	END PROCEDURE AD_EVALUACION;
END PC_EVALUACION;
				
create or replace package PC_ACTIVIDADES IS
PROCEDURE AD_ACTIVIDADES(fechaInicio in DATE,horaInicio in NUMBER,tiempoTotal in NUMBER, pulsacionesProm in REAL);
PROCEDURE AD_ACTIVIDADESLIBRES(libre in NUMBER, idAtleta in NUMBER, numero in NUMBER);
PROCEDURE AD_ACTIVIDADESPLANEADAS(planeadaId in NUMBER, nombre in CHAR, tipo in NUMBER, fechaCreacion in DATE, entrenadorId in NUMBER, idAtleta in NUMBER);
PROCEDURE AD_REGISTRO_ACTIVIDADES(numero in NUMBER, fecha in DATE, hora in NUMBER, sensor in CHAR, valor in NUMBER, numeroActividad in NUMBER);
PROCEDURE CO_ACTIVIDADES(numero in NUMBER, fecha in DATE, hora in NUMBER, valor in NUMBER) return SYS_REFCURSOR;
PROCEDURE CO_ACTIVIDADES(idAtleta in NUMBER, puntaje in NUMBER, numero in NUMBER) return SYS_REFCURSOR;

create or replace package body PC_ACTIVIDADES is
PROCEDURE AD_ACTIVIDAD (fechaInicio in DATE,horaInicio in NUMBER,tiempoTotal in NUMBER, pulsacionesProm in REAL)
	BEGIN
	INSERT INTO ACTIVIDAD(fechaInicio, horaInicio,tiempoTotal,pulsacionesProm) VALUES (xfechaInicio,xhoraInicio,xtiempoTotal, xpulsacionesProm);
	COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR('No se piuede insertar actividades')
	END;

PROCEDURE AD_ACTIVIDADESLIBRES (libre in NUMBER, idAtleta in NUMBER, numero in NUMBER)
	BEGIN
	INSERT INTO ACTIVIDAD(libre,idAtleta,numero) VALUES (xlibre,xidAtleta,xnumero);
	COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR('No se piuede insertar actividades')
	END;

PROCEDURE AD_ACTIVIDADESPLANEADAS(planeadaId in NUMBER, nombre in CHAR, tipo in NUMBER, fechaCreacion in DATE, entrenadorId in NUMBER, idAtleta in NUMBER)
	BEGIN
	INSERT INTO ACTIVIDAD(planeadaId,nombre,tipo,fechaCreacion,entrenadorId,idAtleta) VALUES (xplaneadaId,xnombre,xtipo,xfechaCreacion,xentrenadorId,xidAtleta);
	COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR('No se piuede insertar actividades')
	END;

PROCEDURE AD_REGISTRO_ACTIVIDADES (numero in NUMBER, fecha in DATE, hora in NUMBER, sensor in CHAR, valor in NUMBER, numeroActividad in NUMBER)
	BEGIN
	INSERT INTO ACTIVIDAD(numero,fecha,hora,sensor,valor,numeroActividad) VALUES (xnumero,xfecha,xhora,xsensor,xvalor,xnumeroActividad);
	COMMIT;
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		RAISE_APPLICATION_ERROR('No se piuede insertar registro')
	END;
	

FUNCTION CO_ACTIVIDADES  RETURN SYS_REFCURSOR IS CO_AC SYS_REFCURSOR;
	BEGIN
	OPEN CO_AC  FOR
		SELECT numero,sensor FROM ES_REGISTRO;
	RETURN CO_AC;
	END;

FUNCTION CO_ACTIVIDADES  RETURN SYS_REFCURSOR IS CO_AC SYS_REFCURSOR;
	BEGIN
	OPEN CO_AC  FOR
		SELECT puntaje,numero FROM ES_EVALUACION;
	RETURN CO_AC;
	END;

END PC_ACTIVIDAD;
