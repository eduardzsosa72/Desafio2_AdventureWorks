-- ============================================================
-- DESAFIO PRACTICO 2 - Datawarehouse y Mineria de Datos (DMD 941)
-- Universidad Don Bosco | Ing. Katherine Vigil
-- Script 01: Exploracion de datos - AdventureWorksDW
-- ============================================================

USE AdventureWorksDW2022;
GO

-- ============================================================
-- 1. VERIFICAR QUE LA BD ESTA FUNCIONAL
-- ============================================================
SELECT name AS Tabla, type_desc
FROM sys.tables
WHERE type = 'U'
ORDER BY name;

-- ============================================================
-- 2. TABLAS DE HECHOS - Recuento de filas
-- ============================================================
SELECT 'FactInternetSales'  AS TablaHechos, COUNT(*) AS TotalFilas FROM FactInternetSales
UNION ALL
SELECT 'FactResellerSales',                 COUNT(*) FROM FactResellerSales
UNION ALL
SELECT 'FactSalesQuota',                    COUNT(*) FROM FactSalesQuota;

-- ============================================================
-- 3. EXPLORACION FactInternetSales
-- ============================================================
SELECT TOP 10
    SalesOrderNumber,
    OrderDateKey,
    ProductKey,
    CustomerKey,
    SalesTerritoryKey,
    OrderQuantity,
    UnitPrice,
    SalesAmount,
    TotalProductCost,
    SalesAmount - TotalProductCost AS GananciaBruta
FROM FactInternetSales
ORDER BY SalesAmount DESC;

-- Rango de fechas disponibles
SELECT
    MIN(FullDateAlternateKey) AS FechaInicio,
    MAX(FullDateAlternateKey) AS FechaFin,
    COUNT(DISTINCT CalendarYear) AS TotalAnios
FROM DimDate;

-- ============================================================
-- 4. EXPLORACION FactResellerSales
-- ============================================================
SELECT TOP 10
    SalesOrderNumber,
    OrderDateKey,
    ProductKey,
    ResellerKey,
    SalesTerritoryKey,
    OrderQuantity,
    SalesAmount,
    TotalProductCost,
    SalesAmount - TotalProductCost AS GananciaBruta
FROM FactResellerSales
ORDER BY SalesAmount DESC;

-- ============================================================
-- 5. EXPLORACION DIMENSIONES RELEVANTES
-- ============================================================

-- DimProduct con jerarquia de categoria
SELECT TOP 20
    p.ProductKey,
    p.EnglishProductName          AS Producto,
    p.StandardCost,
    p.ListPrice,
    sub.EnglishProductSubcategoryName AS Subcategoria,
    cat.EnglishProductCategoryName    AS Categoria
FROM DimProduct p
LEFT JOIN DimProductSubcategory sub ON p.ProductSubcategoryKey = sub.ProductSubcategoryKey
LEFT JOIN DimProductCategory    cat ON sub.ProductCategoryKey  = cat.ProductCategoryKey
ORDER BY cat.EnglishProductCategoryName, sub.EnglishProductSubcategoryName;

-- DimDate - Jerarquia temporal
SELECT DISTINCT
    CalendarYear   AS Anio,
    CalendarSemester AS Semestre,
    CalendarQuarter  AS Trimestre,
    EnglishMonthName AS Mes
FROM DimDate
ORDER BY CalendarYear, CalendarQuarter;

-- DimSalesTerritory - Territorios
SELECT
    SalesTerritoryKey,
    SalesTerritoryAlternateKey,
    SalesTerritoryRegion   AS Region,
    SalesTerritoryCountry  AS Pais,
    SalesTerritoryGroup    AS GrupoRegional
FROM DimSalesTerritory
ORDER BY SalesTerritoryGroup, SalesTerritoryCountry;

-- DimCustomer - Vista rapida
SELECT TOP 5
    CustomerKey,
    FirstName + ' ' + LastName AS NombreCliente,
    EnglishEducation           AS Educacion,
    EnglishOccupation          AS Ocupacion,
    YearlyIncome
FROM DimCustomer;

-- ============================================================
-- 6. RESUMEN: Tablas relevantes y por que
-- ============================================================
/*
TABLAS DE HECHOS:
  - FactInternetSales   : Ventas directas al cliente final por Internet
                          Contiene: SalesAmount, OrderQuantity, TotalProductCost, fechas, territorio, producto
  - FactResellerSales   : Ventas a traves de revendedores
                          Contiene: mismas metricas, util para comparar canales (Pregunta B)

DIMENSIONES:
  - DimProduct          : Nombre, costo, precio del producto
  - DimProductSubcategory: Subcategoria (ej: Mountain Bikes, Road Bikes)
  - DimProductCategory  : Categoria padre (Bikes, Accessories, Clothing, Components)
  - DimDate             : Jerarquia temporal: Anio > Semestre > Trimestre > Mes > Dia
  - DimSalesTerritory   : Region geografica: Grupo > Pais > Region
  - DimCustomer         : Perfil del cliente (usado en Internet Sales)
  - DimReseller         : Datos del revendedor (usado en Reseller Sales)
*/
