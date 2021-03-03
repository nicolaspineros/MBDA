--TABLAS--
CREATE TABLE Cliente(
    Clienteid NUMBER(5) NOT NULL,
    Nombre VARCHAR(20) NOT NULL,
    Correo VARCHAR(10),
    Telefono NUMBER(10) NOT NULL,
    Tienda VARCHAR(10),
    DireccionIDClient NUMBER(5)
);

CREATE TABLE HistorialCliente(
    HistorialClientID NUMBER(5) NOT NULL,
    Clienteid NUMBER(5) NOT NULL,
    NumerodeCompras NUMBER(5),
    MontoCompras NUMBER(10)
);

CREATE TABLE Direccion(
    Direccionid INTEGER NOT NULL,
    Ciudad VARCHAR(8) NOT NULL,
    CodigoPostal INTEGER NOT NULL,
    TipodeDireccion VARCHAR(5)
);

CREATE TABLE OrdendeVenta(
    OrdenVentaid INTEGER NOT NULL,
    FechaOrden DATE NOT NULL,
    Clienteid NUMBER(5) NOT NULL,
    Total INTEGER NOT NULL,
    ProductidOrdVent INTEGER NOT NULL,
    DirecionidOrdVent INTEGER NOT NULL
);

CREATE TABLE ProgramaDistribucion(
    PDistribucionid INTEGER NOT NULL,
    FechaOrden DATE,
    FechaEntrega DATE,
    MetodoEntrega VARCHAR(5),
    OrdenVentaidPDistrib INTEGER
);

CREATE TABLE Categoria(
    Categoriaid INTEGER NOT NULL,
    NombreCategoria VARCHAR(8),
    ProductidCateg INTEGER
);

CREATE TABLE Producto(
    Productid INTEGER NOT NULL,
    Nombre VARCHAR(20),
    Precio INTEGER,
    Color CHAR,
    Material CHAR,
    Referencia CHAR,
    Modelo CHAR,
    Marca CHAR,
    Peso INTEGER,
    Talla CHAR,
    Serial INTEGER
);

CREATE TABLE Catalogo(
    Catalogoid INTEGER NOT NULL,
    NombreCompañia CHAR,
    FechaTemporada DATE,
    NombreCatalogo CHAR,
    ProductidCatalog INTEGER
);

CREATE TABLE Vendedor(
    Vendedorid INTEGER NOT NULL,
    NombreCompañia CHAR,
    NIT INTEGER,
    correo CHAR
);

CREATE TABLE Tiene(
    Vendedorid INTEGER NOT NULL,
    Catalogoid INTEGER NOT NULL
);

CREATE TABLE Genera(
    Clienteid INTEGER NOT NULL,
    OrdenVentaid INTEGER NOT NULL
);

--RESTRICCIONES--

ALTER TABLE Cliente ADD CONSTRAINT PK_Cliente
    PRIMARY KEY(Clienteid);
    
ALTER TABLE HistorialCliente ADD CONSTRAINT PK_HistorialCliente
    PRIMARY KEY(HistorialClientID);
    
ALTER TABLE Direccion ADD CONSTRAINT PK_Direccion
    PRIMARY KEY(Direccionid);
    
ALTER TABLE Cliente ADD CONSTRAINT PK_Cliente
    PRIMARY KEY(Clienteid);
    
ALTER TABLE OrdendeVenta ADD CONSTRAINT PK_OrdendeVenta
    PRIMARY KEY(OrdenVentaid);
    
ALTER TABLE ProgramaDistribucion ADD CONSTRAINT PK_ProgramaDistribucion
    PRIMARY KEY(PDistribucionid);

ALTER TABLE Producto ADD CONSTRAINT PK_Producto
    PRIMARY KEY(Productid);

ALTER TABLE Categoria ADD CONSTRAINT PK_Categoria
    PRIMARY KEY(Categoriaid);
    
ALTER TABLE Catalogo ADD CONSTRAINT PK_Catalogo
    PRIMARY KEY(Catalogoid);
    
ALTER TABLE Vendedor ADD CONSTRAINT PK_Vendedor
    PRIMARY KEY(Vendedorid);
    
ALTER TABLE HistorialCliente ADD CONSTRAINT FK_Cliente_HistorialCliente
    FOREIGN KEY(Clienteid) REFERENCES Cliente(Clienteid) ;
    
ALTER TABLE OrdendeVenta ADD CONSTRAINT FK_Cliente_OrdenVenta
    FOREIGN KEY(Clienteid) REFERENCES Cliente(Clienteid) ;
    
ALTER TABLE OrdendeVenta ADD CONSTRAINT FK_Producto_OrdendeVenta
    FOREIGN KEY(ProductidOrdVent) REFERENCES Producto(ProductidOrdVent) ;
    
