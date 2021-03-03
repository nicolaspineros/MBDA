--INTEGRIDAD DECLARATIVA--
--la respuesta no debe exceder los 1000 caracteres--
ALTER TABLE Respuesta ADD CONSTRAINT CK_RESPUESTA_CARACTERES
    CHECK(respuesta > 0 and respuesta < 1000);
    
--pregunta maximo 500 caracteres--
ALTER TABLE Pregunta ADD CONSTRAINT CK_PREGUNTA_CARACTERES
    CHECK(formulacion > 0 and formulacion < 1000);
    



CREATE TABLE Persona(
    tipoDocumento INTEGER NOT NULL,
    numeroDocumento VARCHAR(10) NOT NULL,
    nombre VARCHAR(50),
    apelido VARCHAR(50),
    email VARCHAR(50)
);

CREATE TABLE Estudiante(
    niveleducativo INTEGER, 
    tipoDocumento_P INTEGER NOT NULL,
    numeroDocumento_P VARCHAR(50) NOT NULL
);

CREATE TABLE Tematicas(
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(500),
    tipoDocumento_C INTEGER NOT NULL,
    numeroDocumento_C VARCHAR(10) NOT NULL
);

CREATE TABLE FuenteInformativa(
    codigo INTEGER NOT NULL,
    referencia INTEGER,
    respuesta INTEGER NOT NULL
);

CREATE TABLE FuentesR(
    respuesta INTEGER NOT NULL,
    numero VARCHAR(2),
    fuenteinformativa INTEGER NOT NULL
);

CREATE TABLE Respuesta(
    codigo INTEGER NOT NULL,
    respuesta VARCHAR(100),
    fechaCreacion DATE,
    pregunta INTEGER NOT NULL,
);

CREATE TABLE Proyecto(
    codigo INTEGER NOT NULL,
    tema VARCHAR(50),
    rol VARCHAR(50),
    duracion INTEGER NOT NULL,
    tipodocumentoprofesor INTEGER NOT NULL,
    numerodocumentoprofesor VARCHAR(10) NOT NULL
);

CREATE TABLE Experiencias(
    