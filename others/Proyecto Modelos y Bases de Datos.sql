                    ------TABLAS------
                    
CREATE TABLE BikeWorld(
    NIT INTEGER NOT NULL,
    correo VARCHAR(10),
    Telefono VARCHAR(7),
    Direccion VARCHAR(10)
);

CREATE TABLE Cliente(
    TipoDocumento INTEGER NOT NULL,
    NumeroDocumento VARCHAR(10) NOT NULL,
    Nombre VARCHAR(20) NOT NULL,
    Correo VARCHAR(10),
    Telefono NUMBER(10) NOT NULL,
    Tienda VARCHAR(10),
    DireccionCliente INTEGER NOT NULL
);
CREATE TABLE HistorialCliente(
    TipoDocumento_C INTEGER NOT NULL,
    NumeroDocumento_C VARCHAR(10) NOT NULL,
    NumerodeCompras INTEGER,
    MontoCompras INTEGER
);
CREATE TABLE Direccion(
    Direccionid INTEGER NOT NULL,
    Ciudad VARCHAR(50),
    CodigoPostal INTEGER,
    TipodeDireccion INTEGER 
);
CREATE TABLE OrdenDeVenta(
    OrdenVentaid INTEGER NOT NULL,
    FechaOrden DATE,
    FechaEntrega DATE,
    ValorTotal INTEGER,
    PesoTotal INTEGER,
    ProductidOrdVent INTEGER NOT NULL,
    DirecionidOrdVent INTEGER NOT NULL
);
CREATE TABLE ProgramaDistribucion(
    ProgramaDisid VARCHAR(10) NOT NULL,
    MetodoEntrega VARCHAR(5),
    OrdenVentaidPDistrib INTEGER
);
CREATE TABLE Categoria(
    Categoriaid VARCHAR(10) NOT NULL,
    NombreCategoria VARCHAR(50),
    ProductoidCategoria INTEGER
);
CREATE TABLE Producto(
    Productoid INTEGER NOT NULL,
    Nombre VARCHAR(50),
    Precio INTEGER,
    Color VARCHAR(10) ,
    Material VARCHAR(50),
    Referencia VARCHAR(50),
    Modelo VARCHAR(50),
    Marca VARCHAR(50),
    Peso INTEGER,
    Talla VARCHAR(2),
    Serial VARCHAR(10),
    Genero VARCHAR(10)
);

CREATE TABLE Catalogo(
    Catalogoid INTEGER NOT NULL,
    NombreCompaņia VARCHAR(50),
    FechaTemporada DATE,
    NombreCatalogo VARCHAR(100)
);

CREATE TABLE Vendedor(
    TipoDocumentoV INTEGER NOT NULL,
    NumeroDocumentoV VARCHAR(10) NOT NULL,
    NombreCompaņia VARCHAR(50),
    NIT INTEGER,
    correo VARCHAR(20)
);

CREATE TABLE CatalogoVendedor(
    TipoDocumentoV INTEGER NOT NULL,
    NumeroDocumentoV VARCHAR(10) NOT NULL,
    Catalogoid INTEGER NOT NULL
);

CREATE TABLE ClienteOrdenDeVenta(
    TipoDocumento INTEGER NOT NULL,
    NumeroDocumento VARCHAR(10) NOT NULL,
    OrdenVentaid INTEGER NOT NULL
);

CREATE TABLE ProductoCatalogo(
    Catalogoid INTEGER NOT NULL,
    Productoid INTEGER NOT NULL,
    NumeroCatalogo VARCHAR(5)
);

CREATE TABLE Telefono(
    TipoDocumento INTEGER NOT NULL,
    NumeroDocumento VARCHAR(10) NOT NULL,
    Telefono VARCHAR(10)
);
    
                         --RESTRICCIONES--
---------------------------- PRIMARIAS -----------------------------

ALTER TABLE BikeWorld ADD CONSTRAINT PK_BikeWold
    PRIMARY KEY(NIT);

ALTER TABLE Cliente ADD CONSTRAINT PK_Cliente
    PRIMARY KEY(TipoDocumento,NumeroDocumento);
    
ALTER TABLE HistorialCliente ADD CONSTRAINT PK_HistorialCliente
    PRIMARY KEY(TipoDocumento_C,NumeroDocumento_C);
    
ALTER TABLE Direccion ADD CONSTRAINT PK_Direccion
    PRIMARY KEY(Direccionid);
    
ALTER TABLE OrdenDeVenta ADD CONSTRAINT PK_OrdendeVenta
    PRIMARY KEY(OrdenVentaid);
    
ALTER TABLE ProgramaDistribucion ADD CONSTRAINT PK_ProgramaDistribucion
    PRIMARY KEY(ProgramaDisid);

ALTER TABLE Producto ADD CONSTRAINT PK_Producto
    PRIMARY KEY(Productoid);

ALTER TABLE Categoria ADD CONSTRAINT PK_Categoria
    PRIMARY KEY(Categoriaid);
    
ALTER TABLE Catalogo ADD CONSTRAINT PK_Catalogo
    PRIMARY KEY(Catalogoid);
    
ALTER TABLE Vendedor ADD CONSTRAINT PK_Vendedor
    PRIMARY KEY(TipoDocumentoV,NumeroDocumentoV);
    
ALTER TABLE ClienteOrdenDeVenta ADD CONSTRAINT PK_ClienteOrdenDeVenta
    PRIMARY KEY(TipoDocumento,NumeroDocumento,OrdenVentaid);
    
ALTER TABLE CatalogoVendedor ADD CONSTRAINT PK_CatalogoVendedor
    PRIMARY KEY(TipoDocumentoV,NumeroDocumentoV,Catalogoid);
    
ALTER TABLE ProductoCatalogo ADD CONSTRAINT PK_ProductoCatalogo
    PRIMARY KEY(Catalogoid,Productoid);
    
ALTER TABLE Telefono ADD CONSTRAINT PK_Telefono
    PRIMARY KEY(TipoDocumento,NumeroDocumento);
    
-------------------------- FORANEAS -------------------------    

ALTER TABLE Telefono ADD CONSTRAINT FK_Telefono_Cliente
    FOREIGN KEY(TipoDocumento,NumeroDocumento) REFERENCES Cliente(TipoDocumento,NumeroDocumento);

ALTER TABLE ClienteOrdenDeVenta ADD CONSTRAINT FK_ClienteOrdenDeVenta_Cliente
    FOREIGN KEY(TipoDocumento,NumeroDocumento) REFERENCES Cliente(TipoDocumento,NumeroDocumento);

ALTER TABLE CatalogoVendedor ADD CONSTRAINT FK_CatalogoVendedor_Vendedor
    FOREIGN KEY(TipoDocumentoV,NumeroDocumentoV) REFERENCES Vendedor(TipoDocumentoV,NumeroDocumentoV);
    
ALTER TABLE CatalogoVendedor ADD CONSTRAINT FK_CatalogoVendedor_Catalogo
    FOREIGN KEY(Catalogoid) REFERENCES Catalogo(Catalogoid);
    
ALTER TABLE ProductoCatalogo ADD CONSTRAINT FK_ProductoCatalogo_Producto
    FOREIGN KEY(Productoid) REFERENCES Producto(Productoid);

ALTER TABLE ProductoCatalogo ADD CONSTRAINT FK_ProductoCatalogo_Catalogo
    FOREIGN KEY(Catalogoid) REFERENCES Catalogo(Catalogoid);
    
ALTER TABLE ClienteOrdenDeVenta ADD CONSTRAINT FK_ClienteOrdenV_OrdenV
    FOREIGN KEY(OrdenVentaid) REFERENCES OrdenDeVenta(OrdenVentaid);
    
ALTER TABLE OrdenDeVenta ADD CONSTRAINT FK_OrdenDeVenta_Producto
    FOREIGN KEY(ProductidOrdVent) REFERENCES Producto(Productoid);
    
ALTER TABLE Categoria ADD CONSTRAINT FK_Categoria_Producto
    FOREIGN KEY(ProductoidCategoria) REFERENCES Producto(Productoid);
    
ALTER TABLE ProgramaDistribucion ADD CONSTRAINT Fk_ProgramaDistri_OrdenDeVenta
    FOREIGN KEY(OrdenVentaidPDistrib) REFERENCES OrdenDeVenta(OrdenVentaid);
    
ALTER TABLE OrdenDeVenta ADD CONSTRAINT FK_OrdenDeVenta_Direccion
    FOREIGN KEY (DirecionidOrdVent) REFERENCES Direccion(Direccionid);

ALTER TABLE Vendedor ADD CONSTRAINT FK_Vendedor_Cliente
    FOREIGN KEY(TipoDocumentoV,NumeroDocumentoV) REFERENCES Cliente(TipoDocumento,NumeroDocumento);

ALTER TABLE Cliente ADD CONSTRAINT FK_Cliente_Direccion
    FOREIGN KEY(DireccionCliente) REFERENCES Direccion(Direccionid);
    
    
---------------------- INTEGRIDAD PROCEDIMENTAL----------------------------------
-- REFERENCIALES --


ALTER TABLE Cliente ADD CONSTRAINT CK_Cliente_TCorreo
CHECK (correo like ('%@%') and correo not like ('@%') 
        and correo not like ('%@') and correo not like ('%@%@%'));

ALTER TABLE Vendedor ADD CONSTRAINT CK_Vendedor_TCorreo
CHECK (correo like ('%@%.%') and correo not like ('@%') 
        and correo not like ('%@') and correo not like ('%@%@%'));

ALTER TABLE Vendedor ADD CONSTRAINT CK_Vendedor_Tnit
CHECK(NIT = 10 );

ALTER TABLE Producto ADD CONSTRAINT CK_Producto_PTalla
CHECK(Talla IN ('S','M','L','XL'));

ALTER TABLE Producto ADD CONSTRAINT CK_Producto_TGenero
CHECK(Genero IN ('Masculino','Femenino'));

ALTER TABLE Producto ADD CONSTRAINT CK_Producto_Color
CHECK(color IN ('amarillo','azul','rojo','verde','blanco','negro','morado'));

ALTER TABLE Categoria ADD CONSTRAINT CK_Categoria_Tcategoria
CHECK(NombreCategoria IN ('Ruta','XC','Enduro','Downhill','BMX','Trial','Bicicross'));

ALTER TABLE Cliente ADD CONSTRAINT CK_Cliente_TDocumento
CHECK(TipoDocumento IN ('CC','TI','CE'));

ALTER TABLE Vendedor ADD CONSTRAINT CK_Vendedor_TDocumento
CHECK (TipoDocumentoV IN ('CC','TI','CE'));

ALTER TABLE HistorialCliente ADD CONSTRAINT CK_HistorialCliente_TDocumento
CHECK (TipoDocumento_C IN ('CC','TI','CE'));



create or replace TRIGGER HISTORIALCLIENTE_TG1 
AFTER INSERT ON CLIENTE 
FOR EACH ROW
DECLARE
    TIPODOCUMENTO_C INTEGER;
    NUMERODOCUMENTO_C VARCHAR(10);
BEGIN
    SELECT USER INTO TIPODOCUMENTO_C FROM DUAL;
    SELECT USER INTO NUMERODOCUMENTO_C FROM dual;
    INSERT INTO HISTORIALCLIENTE VALUES(NEW.TIPODOCUMENTO_C,:NEW.NUMERODOCUMENTO);
END;

