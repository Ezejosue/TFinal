USE master;
GO

CREATE DATABASE RentaPelis;
USE RentaPelis;
GO

DROP DATABASE RentaPelis;
GO

CREATE TABLE TipoPelicula
(
    CodigoDepeli VARCHAR(5) NOT NULL,
    NombreTipo VARCHAR(20),

    CONSTRAINT PK_CodigoDepeli PRIMARY KEY(CodigoDepeli),
    CONSTRAINT CK_CodigoDepeli CHECK(CodigoDepeli LIKE '[T][I][0-9][0-9][0-9]'),
    CONSTRAINT U_NombreTipo UNIQUE(NombreTipo)
);
GO

CREATE TABLE CategoriaPelicula
(
    CodigoCategoria VARCHAR(5) NOT NULL,
    NombreCategoria VARCHAR(20),

    CONSTRAINT PK_CodigoCategoria PRIMARY KEY(CodigoCategoria),
    CONSTRAINT CK_CodigoCategoria CHECK(CodigoCategoria LIKE '[C][A][0-9][0-9][0-9]'),

);
GO

CREATE TABLE Cliente
(
    CodigoCliente VARCHAR(5) NOT NULL,
    DUI VARCHAR(10) NOT NULL,
    NombreCliente VARCHAR(20) NOT NULL,
    ApellidoCliente VARCHAR(20) NOT NULL,
    Fecha_Afiliacion DATE DEFAULT GETDATE(),
    Edad INT,

    CONSTRAINT PK_CodigoCliente PRIMARY KEY(CodigoCliente),
    CONSTRAINT CK_CodigoCliente CHECK(CodigoCliente LIKE '[C][L][0-9][0-9][0-9]'),
    CONSTRAINT CK_DUI CHECK(DUI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][-][0-9]'),
    CONSTRAINT CK_Edad CHECK(Edad >= 18 AND Edad <= 90),
    CONSTRAINT U_DUI UNIQUE(DUI),
);
GO

CREATE TABLE Pelicula
(
    CodigoPelicula VARCHAR(5) NOT NULL,
    NombrePelicula VARCHAR(50) NOT NULL,
    Fecha_Ingreso DATE DEFAULT GETDATE(),
    Disponibilidad INT,
    Costo MONEY,
    CodigoDepeli VARCHAR(5) NOT NULL,
    CodigoCategoria VARCHAR(5)NOT NULL,

    CONSTRAINT PK_CodigoPelicula PRIMARY KEY(CodigoPelicula),
    CONSTRAINT FK_CodigoDepeli FOREIGN KEY(CodigoDepeli) REFERENCES TipoPelicula(CodigoDepeli)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT FK_CodigoCategoria FOREIGN KEY(CodigoCategoria) REFERENCES CategoriaPelicula(CodigoCategoria)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    
    CONSTRAINT CK_CodigoPelicula CHECK(CodigoPelicula LIKE '[P][E][0-9][0-9][0-9]'),
    CONSTRAINT CK_Costo CHECK(Costo >= 0),
    CONSTRAINT CK_Disponilidad CHECK(Disponibilidad >= 0),

);
GO

CREATE TABLE Renta
(
    CodigoRenta VARCHAR(5) NOT NULL,
    CodigoCliente VARCHAR(5) NOT NULL,
    CodigoPelicula VARCHAR(5) NOT NULL,
    Fecha_Renta DATE,
    Fecha_Devolucion DATE,
    Mora MONEY,

    CONSTRAINT PK_CodigoRenta PRIMARY KEY(CodigoRenta),
    CONSTRAINT FK_CodigoPelicula FOREIGN KEY(CodigoPelicula) REFERENCES Pelicula(CodigoPelicula)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CONSTRAINT FK_CodigoCliente FOREIGN KEY(CodigoCliente) REFERENCES Cliente(CodigoCliente)
    ON DELETE CASCADE 
    ON UPDATE CASCADE,

    CONSTRAINT CK_CodigoRenta CHECK(CodigoRenta LIKE '[R][E][0-9][0-9][0-9]'),
    CONSTRAINT CK_FechaRenta CHECK(Fecha_Renta < Fecha_Devolucion),
    CONSTRAINT CK_Mora CHECK(Mora >= 0),

);
GO

--INSERTS
INSERT INTO TipoPelicula VALUES
('TI001', 'DVD'),
('TI002', 'Electrónica'),
('TI003', 'Coleccionable');
GO

INSERT INTO CategoriaPelicula VALUES
('CA001', 'Comedia'),
('CA002', 'Acción'),
('CA003', 'Romántica'),
('CA004', 'Drama'),
('CA005', 'Juego');
GO

INSERT INTO Cliente(CodigoCliente, DUI, NombreCliente, ApellidoCliente, Edad) VALUES
('CL001', '12345678-9', 'Isom', 'Kirlin', 18),
('CL002', '45454545-5', 'Cathryn', 'Abbott', 90);

INSERT INTO Cliente VALUES
('CL003', '98745613-8', 'Amiya', 'Hegmann', '10/10/2017', 20),
('CL004', '98745612-3', 'Jude', 'Langosh', '12/04/2018', 25),
('CL005', '65987412-3', 'Regan', 'Jakubowski', '16/02/2020', 30),
('CL006', '25847691-9', 'Elsa', 'Cronin', '07/07/2017', 23),
('CL007', '12365478-7', 'Darrel', 'King', '14/09/2018', 40),
('CL008', '25847196-6', 'Vincenza', 'Nitzsche', '16/08/2015', 50),
('CL009', '45823618-5', 'Keyon', 'Ullrich', '25/06/2015', 29),
('CL010', '54826973-2', 'Michele', 'Kshlerin', '17/01/2019', 35);
GO

INSERT INTO Pelicula(CodigoPelicula, NombrePelicula, Disponibilidad, Costo, CodigoDepeli, CodigoCategoria) VALUES
('PE001', 'Titanic', 20, 7.00, 'TI003', 'CA003'),
('PE002', 'Mujercitas', 17, 10.00, 'TI002', 'CA004');

INSERT INTO Pelicula VALUES
('PE003', 'JOKER', '10/10/2019', 30, 7.00, 'TI002', 'CA002'),
('PE004', 'Midsommar', '18/07/2019', 22, 6.25, 'TI002', 'CA002'),
('PE005', 'Enola Holmes', '25/09/2020', 40, 10.50, 'TI002', 'CA002'),
('PE006', 'Bohemian', '14/09/2018', 12, 7.20, 'TI001', 'CA004'),
('PE007', 'IT', '20/02/2019', 16, 10.00, 'TI001', 'CA001'),
('PE008', 'Yo antes de ti', '17/07/2017', 14, 5.00, 'TI003', 'CA001'),
('PE009', 'John Constantine', '02/04/2015', 30, 5.00, 'TI003', 'CA002'),
('PE010', 'El conjuro', '03/07/2016', 25, 7.00, 'TI002', 'CA002');

INSERT INTO Renta VALUES
('RE001', 'CL001', 'PE001', '10/10/2019', '15/10/2019', 3.00),
('RE002', 'CL002', 'PE001', '18/07/2019', '19/07/2019', NULL),
('RE003', 'CL003', 'PE002', '18/08/2020', '19/08/2020', NULL),
('RE004', 'CL004', 'PE002', '18/07/2020', '20/07/2020', 3.00),
('RE005', 'CL002', 'PE003', '18/11/2019', '20/11/2019', NULL),
('RE006', 'CL007', 'PE004', '18/04/2019', '23/04/2019', 5.00),
('RE007', 'CL007', 'PE005', '07/10/2020', '08/10/2020', NULL),
('RE008', 'CL001', 'PE005', '08/11/2020', '18/11/2020', 3.20),
('RE009', 'CL003', 'PE003', '02/10/2019', '03/10/2019', NULL),
('RE010', 'CL010', 'PE001', '23/11/2020', '28/11/2020', 4.25);


--SELECTS
SELECT * FROM TipoPelicula;
SELECT * FROM CategoriaPelicula;
SELECT * FROM Cliente;
SELECT * FROM Pelicula;
SELECT * FROM Renta;

-- a.
SELECT NombreCliente, Edad FROM Cliente WHERE Edad > 25 ORDER BY Edad ASC

-- b.
SELECT NombreCliente, Edad FROM Cliente WHERE Edad > 18 AND Edad < 26

-- c.
SELECT NombreCliente, Fecha_Afiliacion FROM Cliente WHERE Fecha_Afiliacion > '2008/04/01' AND Fecha_Afiliacion < '2008/06/30'

-- d.
SELECT NombreCliente, R.CodigoCliente FROM Renta R LEFT JOIN Cliente C ON R.CodigoCliente = C.CodigoCliente

-- e.
SELECT SUM(Disponibilidad) AS [Total de DVD en inventario] 
FROM Pelicula P
INNER JOIN TipoPelicula T 
ON P.CodigoDepeli = T.CodigoDepeli
WHERE NombreTipo = 'DVD'

-- f
SELECT CONCAT(NombreCliente, ' ', ApellidoCliente) AS Nombre_Completo, Mora 
FROM Cliente C INNER JOIN Renta R ON C.CodigoCliente=R.CodigoCliente WHERE Mora IS NOT NULL; 

-- g
SELECT CONCAT(NombreCliente, ' ', ApellidoCliente) AS Nombre_Completo, Mora 
FROM Cliente C INNER JOIN Renta R ON C.CodigoCliente=R.CodigoCliente WHERE Mora IS NULL; 

-- h 
SELECT NombrePelicula, Mora FROM Pelicula P INNER JOIN Renta R ON P.CodigoPelicula=R.CodigoPelicula WHERE Mora IS NOT NULL;

-- i 
SELECT NombrePelicula, NombreCategoria FROM Pelicula P INNER JOIN Renta R ON P.CodigoPelicula=R.CodigoPelicula INNER JOIN CategoriaPelicula CP ON
P.CodigoCategoria = CP.CodigoCategoria WHERE CP.NombreCategoria = 'Comedia';

-- j
SELECT P.NombrePelicula FROM Pelicula P LEFT JOIN Renta R ON P.CodigoPelicula=R.CodigoPelicula WHERE CodigoRenta IS NULL;


-- VISTAS
-- a.
CREATE VIEW dbo.rentasClientes (Cliente, Veces)
AS
	SELECT NombreCliente, COUNT(R.CodigoCliente) 
	FROM Renta R 
	LEFT JOIN Cliente C 
	ON R.CodigoCliente = C.CodigoCliente 
	GROUP BY NombreCliente
GO

SELECT * FROM rentasClientes WHERE Veces >= 2;


-- b.
CREATE VIEW dbo.primerasRentadas ([Codigo de pelicula], [Pelicula rentada], [Fecha de renta])
AS
	SELECT TOP 4(R.CodigoPelicula), NombrePelicula, Fecha_Renta
	FROM Renta R 
	LEFT JOIN Pelicula P
	ON R.CodigoPelicula = P.CodigoPelicula 
GO

SELECT * FROM primerasRentadas;

-- c.
CREATE VIEW dbo.categoriasAlquiladas ([Categoria], [Veces vendida])
AS	
	SELECT NombreCategoria, COUNT(NombreCategoria)
	FROM CategoriaPelicula C
	INNER JOIN Pelicula P
	ON C.CodigoCategoria = P.CodigoCategoria
	RIGHT JOIN Renta R
	ON P.CodigoPelicula = R.CodigoPelicula
	GROUP BY NombreCategoria
GO

SELECT [Categoria], [Veces vendida] FROM categoriasAlquiladas WHERE [Veces vendida] IN (SELECT MAX([Veces vendida]) FROM categoriasAlquiladas);
SELECT [Categoria], [Veces vendida] FROM categoriasAlquiladas WHERE [Veces vendida] IN (SELECT MIN([Veces vendida]) FROM categoriasAlquiladas);

-- d.

CREATE VIEW dbo.peliculasEnconceptodeDinero ([Nombre Pelicula], [TOTAL])
AS  
    SELECT P.NombrePelicula, (COUNT(R.CodigoPelicula)*P.Costo)+R.Mora
    FROM Pelicula P INNER JOIN Renta R ON P.CodigoPelicula = R.CodigoPelicula
    GROUP BY P.NombrePelicula, P.Costo, R.Mora 
    HAVING (COUNT(R.CodigoPelicula)*P.Costo)+R.Mora > 0
GO

SELECT * FROM dbo.peliculasEnconceptodeDinero;

-- e.
CREATE VIEW dbo.RentaPersona ([Nombre Pelicula], [Nombre Completo], [Fecha Renta])
AS
    SELECT TOP 5 P.NombrePelicula, CONCAT(C.NombreCliente, ' ', C.ApellidoCliente), R.Fecha_Renta
    FROM Pelicula P INNER JOIN Renta R ON P.CodigoPelicula=R.CodigoPelicula INNER JOIN Cliente C ON C.CodigoCliente = R.CodigoCliente WHERE R.Fecha_Renta >= DATEADD(MONTH, -11, GETDATE());

GO

SELECT * FROM dbo.RentaPersona;


-- PROCEDIMIENTOS ALMACENADOS
-- a.
CREATE PROCEDURE cantidadPeliculas
AS
	SELECT NombrePelicula, Disponibilidad
	FROM Pelicula
	ORDER BY Disponibilidad
GO

EXEC cantidadPeliculas 


-- b.

CREATE PROCEDURE calcularTotal @Total money OUTPUT
AS
	DECLARE @TotalCosto money
	DECLARE @TotalMora money

	SET @TotalCosto = (SELECT SUM(Costo) FROM Pelicula);
	SET @TotalMora = (SELECT SUM(Mora) FROM Renta WHERE Mora IS NOT NULL);
	SET @Total = @TotalCosto + @TotalMora;
GO

DECLARE @TotalReturn money;
EXEC calcularTotal @TotalReturn OUTPUT;
SELECT [Total recaudado] = @TotalReturn;


-- c.

CREATE PROCEDURE peliculasCliente @NombreCliente varchar(20)
AS
	SELECT NombrePelicula
	FROM Renta R
	LEFT JOIN Cliente C
	ON R.CodigoCliente = C.CodigoCliente
	INNER JOIN Pelicula P
	ON R.CodigoPelicula = P.CodigoPelicula
	INNER JOIN CategoriaPelicula CG
	ON P.CodigoCategoria = CG.CodigoCategoria
	WHERE NombreCliente = 'Darrel'
GO 

EXEC peliculasCliente 'Darrel'

-- d.
CREATE PROCEDURE sp_datosPelicula
    @Nombrepelicula VARCHAR(50)
AS
BEGIN TRY
BEGIN TRAN
IF(SELECT COUNT(*)
FROM Pelicula
WHERE NombrePelicula=@Nombrepelicula)=1
    SELECT P.NombrePelicula, C.NombreCategoria, P.Disponibilidad
FROM Pelicula P INNER JOIN CategoriaPelicula C ON P.CodigoCategoria = C.CodigoCategoria
WHERE P.NombrePelicula = @Nombrepelicula
    ELSE 
    PRINT'Esa pelicula no existe'
commit
end try
begin catch
rollback
print error_message()
end catch;
GO

EXEC datosPelicula 'Titanic';

-- e.
CREATE PROCEDURE sp_Recaudacion
    @Dinero MONEY
AS
	SELECT P.NombrePelicula, COUNT(R.CodigoPelicula)*P.Costo FROM Pelicula P INNER JOIN Renta R ON P.CodigoPelicula = R.CodigoPelicula GROUP BY P.Costo, p.NombrePelicula
	HAVING @Dinero>=( SELECT COUNT(R.CodigoPelicula)*P.Costo )
	
GO

EXEC sp_Recaudacion 20.00;

-- f.

CREATE PROCEDURE sp_datosDUI
    @DUI VARCHAR(10)
AS
BEGIN TRY
BEGIN TRAN
IF(SELECT COUNT(*)
FROM Cliente
WHERE DUI=@DUI)=1
    SELECT *
FROM Cliente
WHERE DUI = @DUI
    ELSE 
    PRINT'Esa DUI no existe'
commit
end try
begin catch
rollback
print error_message()
end catch;
GO

EXEC sp_datosDUI '12345678-9';


--TRIGGER
CREATE TRIGGER CalculodeMora
ON Renta 
AFTER UPDATE
AS
IF UPDATE(Fecha_Devolucion)
BEGIN 
UPDATE Renta SET Mora=(SELECT DATEDIFF(DAY, Fecha_Renta, Fecha_Devolucion)*1.50)
WHERE CodigoRenta = (SELECT i.CodigoRenta FROM inserted i);
PRINT'Se ingreso la mora'
END
GO

UPDATE Renta SET Fecha_Devolucion='2019-11-24' WHERE CodigoRenta= 'RE005'

SELECT * FROM Renta;