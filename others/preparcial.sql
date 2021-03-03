CREATE TABLE Beneficiario(
    tipoDocumento CHAR NOT NULL,
    numeroDocumento NUMBER(15) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    fechaNacimiento DATE,
    responsable VARCHAR(2) NOT NULL
);

CREATE TABLE LiderSocial(
    tipoDocumento CHAR NOT NULL,
    numeroDocumento NUMBER(15) NOT NULL,
    nivelFormacion VARCHAR(20)
);

CREATE TABLE Familia(
    codigo INTEGER NOT NULL,
    fechaRegistro DATE,
    telefono VARCHAR(10),
    municipio INTEGER,
    codigoPrg INTEGER
);

CREATE TABLE Programa(
    codigo INTEGER NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    objetivo VARCHAR(200),
    costoEstimado INTEGER
);

CREATE TABLE Capacitacion(
    codigo INTEGER NOT NULL,
    hora TIMESTAMP,
    duracion INTEGER,
    cupos INTEGER,
    codigoauditorio INTEGER
);

CREATE TABLE Servicio(
    codigo INTEGER NOT NULL,
    fecha DATE, 
    coodigopgr INTEGER NOT NULL,
    tipoDocumento CHAR NOT NULL,
    numeroDocumento NUMBER(15) NOT NULL
);

CREATE TABLE ValoracionMedica(
    codigoServicio INTEGER NOT NULL,
    hora TIMESTAMP,
    peso CHAR,
    talla CHAR,
    tratamientoDesparacitacion VARCHAR(50)
);

CREATE TABLE TratamientoMicronutrientes(
    idTM INTEGER NOT NULL,
    tratamientoMicronutrientes VARCHAR(50),
    codigoServicio INTEGER NOT NULL
);

CREATE TABLE Huerta(
    codigoServicio INTEGER NOT NULL,
    ubicacion VARCHAR(50),
    areatotal INTEGER,
    codigoFamilia INTEGER NOT NULL
);

CREATE TABLE Auditorio(
    codigo INTEGER NOT NULL,
    direccion VARCHAR(50),
    codigoMunicipio INTEGER NOT NULL
)
    
