--Tablas
create table BIENES (
	codigo CHAR(7) NOT NULL,
	nombre VARCHAR(30) NOT NULL,
	medida CHAR(2) NOT NULL,
	unitario NUMBER(5) NOT NULL,
	retirado CHAR(1) NOT NULL
);

create table FAMILIAS (
	numero NUMBER(5) NOT NULL,
    representante NUMBER(5) NOT NULL
);

create table PERSONAS (
	codigo NUMBER(7) NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	familia NUMBER(5)
);

create table ASIGNACIONES (
	numero NUMBER(9) NOT NULL,
	fecha DATE NOT NULL,
	aceptado CHAR(1),
	familia NUMBER(5) NOT NULL
);

create table BIENESASIGNADOS(
	asignacion NUMBER(9) NOT NULL,
    bien CHAR(7) NOT NULL
);

create table OPINIONES(
    numero NUMBER(5) NOT NULL,
    fecha DATE NOT NULL,
    opinion VARCHAR(1) NOT NULL,
    justificacion VARCHAR(20) NOT NULL,
    persona NUMBER(7) NOT NULL,
    bien CHAR(7) NOT NULL
);

create table OPINIONESGRUPALES(
    opiniongrupalid INTEGER NOT NULL,
    estrellas NUMBER(1),
    opinion NUMBER(5) NOT NULL,
    detalle XMLType
);

create table BIENESFAMILIA(
    familia NUMBER(5) NOT NULL,
    codigof CHAR(7) NOT NULL
);



-- Primarias PKS --

ALTER TABLE BIENES ADD CONSTRAINT PK_BIENES
	PRIMARY KEY(codigo);

ALTER TABLE PERSONAS ADD CONSTRAINT PK_PERSONAS
	PRIMARY KEY(codigo);
    
ALTER TABLE FAMILIAS ADD CONSTRAINT PK_FAMILIAS
	PRIMARY KEY(numero);

ALTER TABLE BIENESASIGNADOS ADD CONSTRAINT PK_BIENESASIGNADOS
	PRIMARY KEY(asignacion,bien);
    
ALTER TABLE BIENESFAMILIA ADD CONSTRAINT PK_BIENESFAMILIA
	PRIMARY KEY(familia,codigof);
    
ALTER TABLE OPINIONESGRUPALES ADD CONSTRAINT PK_OPINIONESGRUPALES
	PRIMARY KEY(opiniongrupalid);
    
ALTER TABLE OPINIONES ADD CONSTRAINT PK_OPINIONES
	PRIMARY KEY(numero);
    
ALTER TABLE ASIGNACIONES ADD CONSTRAINT PK_
	PRIMARY KEY(numero);
    
-- FORANEAS FKS --

ALTER TABLE OPINIONESGRUPALES ADD CONSTRAINT FK_OPINIONESGRUPALES
	FOREIGN KEY(opinion) REFERENCES OPINIONES(numero);
    
ALTER TABLE OPINIONES ADD CONSTRAINT FK_OPINIONES
	FOREIGN KEY(persona) REFERENCES PERSONAS(codigo);
    
ALTER TABLE OPINIONES ADD CONSTRAINT FK_OPINIONES
	FOREIGN KEY(bien) REFERENCES  BIENES(codigo);
    
ALTER TABLE PERSONAS ADD CONSTRAINT FK_PERSONAS
	FOREIGN KEY(familia) REFERENCES FAMILIAS(numero);

ALTER TABLE BIENESFAMILIA ADD CONSTRAINT FK_BIENESFAMILIA
	FOREIGN KEY(familia) REFERENCES FAMILIAS(numero);

ALTER TABLE BIENESFAMILIA ADD CONSTRAINT FK_BIENESFAMILIA
	FOREIGN KEY(codigof) REFERENCES BIENES(codigo);
    
ALTER TABLE BIENESASIGNADOS ADD CONSTRAINT FK_BIENESASIGNADOS
	FOREIGN KEY(asignacion) REFERENCES ASIGNACIONES(numero);

ALTER TABLE BIENESASIGNADOS ADD CONSTRAINT FK_BIENESASIGNADOS
	FOREIGN KEY(bien) REFERENCES BIENES(codigo); 
    
ALTER TABLE ASIGNACIONES  ADD CONSTRAINT FK_ASIGNACIONES
	FOREIGN KEY(familia) REFERENCES FAMILIAS(numero);

-- Unica UK --

ALTER TABLE OPINIONES ADD CONSTRAINT UK_OPINIONES
    UNIQUE(justificacion);


-- POBLAR OK --

insert into OPINIONES (numero,fecha,opinion,justificacion,persona,bien) values (12345,10/2/2020,'E','buen trabajo',1,'#da0844');
insert into OPINIONES (numero,fecha,opinion,justificacion,persona,bien) values (14221,17/4/2020,'R','Puede mejorar',3,'#2a9d03');
insert into OPINIONES (numero,fecha,opinion,justificacion,persona,bien) values (12121,10/1/2020,'B','buen trabajo',5,'#c7f44b');
insert into OPINIONES (numero,fecha,opinion,justificacion,persona,bien) values (12312,12/3/2020,'M','mal aspecto',1,'#b6318c');
insert into OPINIONES (numero,fecha,opinion,justificacion,persona,bien) values (11111,20/2/2020,'E','excelente diseño',1,'#7ab0e9');

insert into OPINIONESGRUPALES (opiniongrupalid,estrellas,opinion,detalle) values (1,2,12345,null);
insert into OPINIONESGRUPALES (opiniongrupalid,estrellas,opinion,detalle) values (2,5,12121,null);
insert into OPINIONESGRUPALES (opiniongrupalid,estrellas,opinion,detalle) values (3,null,12312,null);
insert into OPINIONESGRUPALES (opiniongrupalid,estrellas,opinion,detalle) values (4,null,11111,null);
insert into OPINIONESGRUPALES (opiniongrupalid,estrellas,opinion,detalle) values (5,null,14221,null);

-- CONSULTA --

SELECT BIENES.CODIGO, BIENES.NOMBRE  
FROM BIENES JOIN OPINIONES ON (CODIGO = BIEN) JOIN OPINIONESGRUPALES ON (OPINION.NUMERO = OPINIONGRUPAL.NUMERO)
WHERE OPINION.OPINION = 'E' AND OPINIONGRUPAL.ESTRELLAS > 3;

-- DTD --

<!DOCTYPE RegistroOP [
    <!ELEMENT TDetalle (Estructura, Valor, Cantidad, opinionpersonal)>
		
    <!ELEMENT Estructura (#PCDATA)>                               
    <!ELEMENT Valor (#PCDATA)>
    <!ELEMENT Cantidad (#PCDATA)>
    <!ELEMENT Opinionpersonal (Detalle*)>
    <!ATTLIST Detalle 
            Opinion CDATA #REQUIRED>                                
	
]>

<TDetalle>
        <Estructura>Bastante concisa y conforme a mis gustos</Estructura>
        <Valor>$10000</Valor>
        <Cantidad>2 Bienes</Cantidad>
        <Opinionpersonal>
            <Detalle Opinion = 'muy buena calidad'>
                    Se puede considerar adquirir el bien
            </Detalle>
        </Opinionpersonal>
    </TDetalle>

-- TRIGGERS --

CREATE SEQUENCE numerof START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER TG_Ufamilias
  BEFORE INSERT ON familias
  FOR EACH ROW
BEGIN
  :new.numero := numerof.nextval;
END;


-- PAQUETES --

CREATE OR REPLACE PACKAGE PC_OPINION IS
    PROCEDURE AD_Opinion (xnumero IN NUMBER,xfecha IN DATE,xopinion IN VARCHAR ,xjustificacion IN VARCHAR,xpersona IN NUMBER,xbien IN VARCHAR);
    FUNCTION CO_Opinion RETURN SYS_REFCURSOR;
END PC_OPINION;

CREATE OR REPLACE PACKAGE BODY PC_OPINION IS 
    PROCEDURE AD_Opinion (xnumero IN NUMBER,xfecha IN DATE,xopinion IN VARCHAR ,xjustificacion IN VARCHAR,xpersona IN NUMBER,xbien IN VARCHAR) IS
    BEGIN
        INSERT INTO OPINIONES(numero,fecha,opinion,justificacion,persona,bien) VALUES(xnumero,xfecha,xopinion,xjustificacion,xpersona,xbien);
        COMMIT;
        EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR (-20010,'No se puede insertar la opinion');
    END;
    
    FUNCTION CO_Opinion RETURN SYS_REFCURSOR IS CO_OP SYS_REFCURSOR;
    BEGIN
        OPEN CO_OP FOR
            SELECT * FROM OPINIONES;
        RETURN CO_OP;
    END;
END PC_OPINION;


-- SEGURIDAD --

CREATE OR REPLACE PACKAGE PA_PARTICIPANTE IS 
    PROCEDURE AD_Opin (xnumero IN NUMBER,xfecha IN DATE,xopinion IN VARCHAR ,xjustificacion IN VARCHAR,xpersona IN NUMBER,xbien IN VARCHAR);
    FUNCTION CO_Opin RETURN SYS_REFCURSOR;
END PA_PARTICIPANTE;

CREATE OR REPLACE PACKAGE BODY PA_PARTICIPANTE IS
    PROCEDURE AD_Opin (xnumero IN NUMBER,xfecha IN DATE,xopinion IN VARCHAR ,xjustificacion IN VARCHAR,xpersona IN NUMBER,xbien IN VARCHAR) IS
    BEGIN 
        PC_OPINION.AD_Opinion(numero,fecha,opinion,justificacion,persona,bien);
    COMMIT;
		EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			RAISE_APPLICATION_ERROR(-20032,'No se puede insertar opinion');
	END;
    


insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#da0844', 'Tart Shells', 2, 402, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#2a9d03', 'The Pop Shoppe', 2, 7868, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#b426a1', 'Mix - Cocktai', 1, 7817, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#c7f44b', 'Nantucket - Orange', 1, 9744, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#87dc73', 'Sugar - White Packet', 1, 643, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#fd4c1f', 'Whmis - Spray Bottle', 1, 9653, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#b6318c', 'Cheese - Mozzarella', 1, 8908, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#34e5ef', 'Wine - Black', 2, 4778, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#000df3', 'Cheese - Marble', 2, 3459, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#0eb0c6', 'Bread - Italian', 1, 6484, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#312fd8', 'Sorrel - Fresh', 3, 7918, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#b6318c', 'Cup - Paper', 3, 806, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#7ab0e9', 'Ecolab Digiclean', 1, 572, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#dc627b', 'Bread - Pita', 3, 10835, 1);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#fc4fda', 'Nut - Pistachio', 2, 9709, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#3467ac', 'Banana - Green', 1, 8972, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#8ec115', 'Wine - Acient', 1, 7506, 1);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#ed5496', 'Wine - White', 3, 6058, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#c8fb20', 'Magnotta Bel', 1, 5831, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#2be3c8', 'Corn Shoots', 1, 2755, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#3123d7', 'Creme De Menthen', 1, 8740, 1);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#eac3eb', 'Wine - Periguita', 2, 515, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#461290', 'Wine - Puligny', 2, 75010, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#71b878', 'Capicola - Hot', 2, 31945, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#cedcf1', 'Soup - Campbells', 3, 62633, 1);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#81d56e', 'Sauce - Plum', 3, 4463, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#b01422', 'Ginger - Fresh', 1, 79088, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#3291a4', 'Pasta - Fettuccine', 2, 6971, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#cdf788', 'Squid Ink', 2, 63593, 0);
insert into BIENES (codigo, nombre, medida, unitario, retirado) values ('#2e34eb', 'Kellogs Cereal', 2, 12907, 0);

insert into FAMILIAS (numero, representante) values (1,42);
insert into FAMILIAS (numero, representante) values (2,34);
insert into FAMILIAS (numero, representante) values (3,37);
insert into FAMILIAS (numero, representante) values (4,38);
insert into FAMILIAS (numero, representante) values (5,49);
insert into FAMILIAS (numero, representante) values (6,50);
insert into FAMILIAS (numero, representante) values (7,35);
insert into FAMILIAS (numero, representante) values (8,39);
insert into FAMILIAS (numero, representante) values (9,26);
insert into FAMILIAS (numero, representante) values (10,24);

insert into PERSONAS (codigo, nombre, familia) values (1, 'Kevan Orcas', 9);
insert into PERSONAS (codigo, nombre, familia) values (2, 'Cynthie Calvey', 2);
insert into PERSONAS (codigo, nombre, familia) values (3, 'Mordecai Drayn', 3);
insert into PERSONAS (codigo, nombre, familia) values (4, 'Melinda Velareal', 5);
insert into PERSONAS (codigo, nombre, familia) values (5, 'Natividad Rudkin', 4);
insert into PERSONAS (codigo, nombre, familia) values (6, 'Diann Kielty', 6);
insert into PERSONAS (codigo, nombre, familia) values (7, 'Stacee Rettie', 7);
insert into PERSONAS (codigo, nombre, familia) values (8, 'Claudius Francois', 9);
insert into PERSONAS (codigo, nombre, familia) values (9, 'Camila Strettell', 4);
insert into PERSONAS (codigo, nombre, familia) values (10, 'Vivie MacPaik', 4);
insert into PERSONAS (codigo, nombre, familia) values (11, 'Petr Leifer', 9);
insert into PERSONAS (codigo, nombre, familia) values (12, 'Mara Wake', 6);
insert into PERSONAS (codigo, nombre, familia) values (13, 'Elsa Roisen', 1);
insert into PERSONAS (codigo, nombre, familia) values (14, 'Ingamar Elgar', 5);
insert into PERSONAS (codigo, nombre, familia) values (15, 'Cad Greer', 4);
insert into PERSONAS (codigo, nombre, familia) values (16, 'Reinaldo Scarfe', 3);
insert into PERSONAS (codigo, nombre, familia) values (17, 'Garrick Sewley', 1);
insert into PERSONAS (codigo, nombre, familia) values (18, 'Kimberlyn Mannakee', 4);
insert into PERSONAS (codigo, nombre, familia) values (19, 'Genovera Jouannisson', 2);
insert into PERSONAS (codigo, nombre, familia) values (20, 'Boycey Oakton', 10);
insert into PERSONAS (codigo, nombre, familia) values (21, 'Merla Leneham', 2);
insert into PERSONAS (codigo, nombre, familia) values (22, 'Julio Mathewson', 3);
insert into PERSONAS (codigo, nombre, familia) values (23, 'Tabatha Brasseur', 6);
insert into PERSONAS (codigo, nombre, familia) values (24, 'Shanta Rumbold', 10);
insert into PERSONAS (codigo, nombre, familia) values (25, 'Dory Chadbourn', 3);
insert into PERSONAS (codigo, nombre, familia) values (26, 'Cornelia Gremain', 9);
insert into PERSONAS (codigo, nombre, familia) values (27, 'Say Wotherspoon', 1);
insert into PERSONAS (codigo, nombre, familia) values (28, 'Brant Puddifer', 3);
insert into PERSONAS (codigo, nombre, familia) values (29, 'Blancha Rathjen', 2);
insert into PERSONAS (codigo, nombre, familia) values (30, 'Den Sibary', 7);
insert into PERSONAS (codigo, nombre, familia) values (31, 'Ofelia Ringwood', 1);
insert into PERSONAS (codigo, nombre, familia) values (32, 'Isabel McAlindon', 2);
insert into PERSONAS (codigo, nombre, familia) values (33, 'Molly Purcell', 5);
insert into PERSONAS (codigo, nombre, familia) values (34, 'Homerus Richardt', 2);
insert into PERSONAS (codigo, nombre, familia) values (35, 'Roger Cashley', 7);
insert into PERSONAS (codigo, nombre, familia) values (36, 'Caye De Vaux', 1);
insert into PERSONAS (codigo, nombre, familia) values (37, 'Reuven Vieyra', 3);
insert into PERSONAS (codigo, nombre, familia) values (38, 'Sibella Staddart', 4);
insert into PERSONAS (codigo, nombre, familia) values (39, 'Roseann Igoe', 8);
insert into PERSONAS (codigo, nombre, familia) values (40, 'Burl Swatridge', 1);
insert into PERSONAS (codigo, nombre, familia) values (41, 'Chevy Edgell', 6);
insert into PERSONAS (codigo, nombre, familia) values (42, 'Kaye Menham', 1);
insert into PERSONAS (codigo, nombre, familia) values (43, 'Ronny De Marchi', 5);
insert into PERSONAS (codigo, nombre, familia) values (44, 'Maiga McCrae', 5);
insert into PERSONAS (codigo, nombre, familia) values (45, 'Bryana Lampaert', 6);
insert into PERSONAS (codigo, nombre, familia) values (46, 'Kanya Tolworth', 6);
insert into PERSONAS (codigo, nombre, familia) values (47, 'Everett Charpling', 6);
insert into PERSONAS (codigo, nombre, familia) values (48, 'Spense Pahler', 5);
insert into PERSONAS (codigo, nombre, familia) values (49, 'Aldrich Boatwright', 5);
insert into PERSONAS (codigo, nombre, familia) values (50, 'Klarrisa Bennitt', 6);


insert into ASIGNACIONES (numero, fecha, aceptado, familia) values (1, TO_DATE('05/01/2019','DD/MM/YYYY') , 1, 2);
insert into ASIGNACIONES (numero, fecha, aceptado, familia) values (2, TO_DATE('08/01/2019','DD/MM/YYYY'), 1, 10);
insert into ASIGNACIONES (numero, fecha, aceptado, familia) values (3, TO_DATE('14/02/2019','DD/MM/YYYY'), 1, 5);
insert into ASIGNACIONES (numero, fecha, aceptado, familia) values (4, TO_DATE('08/02/2019','DD/MM/YYYY'), 1, 1);
insert into ASIGNACIONES (numero, fecha, aceptado, familia) values (5, TO_DATE('10/10/2019','DD/MM/YYYY'), 1, 7);
insert into ASIGNACIONES (numero, fecha, aceptado, familia) values (6, TO_DATE('29/11/2019','DD/MM/YYYY'), 1, 5);
insert into ASIGNACIONES (numero, fecha, aceptado, familia) values (7, TO_DATE('11/01/2020','DD/MM/YYYY'), 1, 10);
insert into ASIGNACIONES (numero, fecha, aceptado, familia) values (8, TO_DATE('10/02/2020','DD/MM/YYYY'), 0, 3);
insert into ASIGNACIONES (numero, fecha, aceptado, familia) values (9, TO_DATE('17/03/2020','DD/MM/YYYY'), 1, 5);
insert into ASIGNACIONES (numero, fecha, aceptado, familia) values (10, TO_DATE('05/04/2020','DD/MM/YYYY'), 1, 3);
insert into ASIGNACIONES (numero, fecha, aceptado, familia) values (11, TO_DATE('01/05/2020','DD/MM/YYYY'), 1, 1);
insert into ASIGNACIONES (numero, fecha, aceptado, familia) values (12, TO_DATE('02/06/2020','DD/MM/YYYY'), 1, 1);
insert into ASIGNACIONES (numero, fecha, aceptado, familia) values (13, TO_DATE('31/07/2020','DD/MM/YYYY'), 1, 1);
insert into ASIGNACIONES (numero, fecha, aceptado, familia) values (14, TO_DATE('19/08/2020','DD/MM/YYYY'), NULL, 8);
insert into ASIGNACIONES (numero, fecha, aceptado, familia) values (15, TO_DATE('02/10/2020','DD/MM/YYYY'), NULL, 2);

insert into BIENESASIGNADOS (asignacion, bien) values (1, '#2e34eb');
insert into BIENESASIGNADOS (asignacion, bien) values (1, '#87dc73');
insert into BIENESASIGNADOS (asignacion, bien) values (1, '#3123d7');
insert into BIENESASIGNADOS (asignacion, bien) values (1, '#87dc73');
insert into BIENESASIGNADOS (asignacion, bien) values (1, '#3467ac');
insert into BIENESASIGNADOS (asignacion, bien) values (2, '#3467ac');
insert into BIENESASIGNADOS (asignacion, bien) values (2, '#cedcf1');
insert into BIENESASIGNADOS (asignacion, bien) values (3, '#87dc73');
insert into BIENESASIGNADOS (asignacion, bien) values (3, '#8ec115');
insert into BIENESASIGNADOS (asignacion, bien) values (3, '#3467ac');
insert into BIENESASIGNADOS (asignacion, bien) values (3, '#000df3');
insert into BIENESASIGNADOS (asignacion, bien) values (3, '#3123d7');
insert into BIENESASIGNADOS (asignacion, bien) values (4, '#2e34eb');
insert into BIENESASIGNADOS (asignacion, bien) values (4, '#3291a4');
insert into BIENESASIGNADOS (asignacion, bien) values (4, '#3467ac');
insert into BIENESASIGNADOS (asignacion, bien) values (4, '#cedcf1');
insert into BIENESASIGNADOS (asignacion, bien) values (5, '#2e34eb');
insert into BIENESASIGNADOS (asignacion, bien) values (5, '#3291a4');
insert into BIENESASIGNADOS (asignacion, bien) values (5, '#000df3');
insert into BIENESASIGNADOS (asignacion, bien) values (6, '#2e34eb');
insert into BIENESASIGNADOS (asignacion, bien) values (6, '#3291a4');
insert into BIENESASIGNADOS (asignacion, bien) values (7, '#8ec115');
insert into BIENESASIGNADOS (asignacion, bien) values (7, '#87dc73');
insert into BIENESASIGNADOS (asignacion, bien) values (8, '#000df3');
insert into BIENESASIGNADOS (asignacion, bien) values (8, '#cedcf1');
insert into BIENESASIGNADOS (asignacion, bien) values (9, '#cedcf1');
insert into BIENESASIGNADOS (asignacion, bien) values (10, '#000df3');
insert into BIENESASIGNADOS (asignacion, bien) values (10, '#cedcf1');
insert into BIENESASIGNADOS (asignacion, bien) values (11, '#3291a4');
insert into BIENESASIGNADOS (asignacion, bien) values (11, '#000df3');
insert into BIENESASIGNADOS (asignacion, bien) values (11, '#87dc73');
insert into BIENESASIGNADOS (asignacion, bien) values (11, '#2e34eb');
insert into BIENESASIGNADOS (asignacion, bien) values (13, '#000df3');
insert into BIENESASIGNADOS (asignacion, bien) values (13, '#2e34eb');
insert into BIENESASIGNADOS (asignacion, bien) values (13, '#87dc73');
insert into BIENESASIGNADOS (asignacion, bien) values (14, '#000df3');
insert into BIENESASIGNADOS (asignacion, bien) values (14, '#3291a4');
insert into BIENESASIGNADOS (asignacion, bien) values (14, '#3467ac');
insert into BIENESASIGNADOS (asignacion, bien) values (14, '#cedcf1');
insert into BIENESASIGNADOS (asignacion, bien) values (15, '#3123d7');
insert into BIENESASIGNADOS (asignacion, bien) values (15, '#000df3');
insert into BIENESASIGNADOS (asignacion, bien) values (15, '#8ec115');

