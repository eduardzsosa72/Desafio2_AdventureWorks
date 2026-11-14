-- ============================================================
-- DESAFIO PRACTICO 2 - Datawarehouse y Mineria de Datos (DMD 941)
-- Universidad Don Bosco | Ing. Katherine Vigil
-- Script 02: Consultas SQL para las 3 Preguntas de Negocio
-- ============================================================

USE AdventureWorksDW2022;
GO

-- ============================================================
-- PREGUNTA A
-- ¿Cuales son las categorias y subcategorias de productos con
-- mayor volumen de ventas por año, y como varia esta tendencia
-- trimestre a trimestre?
-- ============================================================

SELECT
    d.CalendarYear                        AS Anio,
    d.CalendarQuarter                     AS Trimestre,
    cat.EnglishProductCategoryName        AS Categoria,
    sub.EnglishProductSubcategoryName     AS Subcategoria,
    SUM(f.OrderQuantity)                  AS VolumenUnidades,
    SUM(f.SalesAmount)                    AS VentasTotales,
    SUM(f.SalesAmount - f.TotalProductCost) AS GananciaBruta,
    ROUND(
        SUM(f.SalesAmount - f.TotalProductCost) /
        NULLIF(SUM(f.SalesAmount), 0) * 100, 2
    )                                     AS MargenPct
FROM FactInternetSales f
JOIN DimDate               d   ON f.OrderDateKey         = d.DateKey
JOIN DimProduct            p   ON f.ProductKey           = p.ProductKey
JOIN DimProductSubcategory sub ON p.ProductSubcategoryKey = sub.ProductSubcategoryKey
JOIN DimProductCategory    cat ON sub.ProductCategoryKey  = cat.ProductCategoryKey
GROUP BY
    d.CalendarYear,
    d.CalendarQuarter,
    cat.EnglishProductCategoryName,
    sub.EnglishProductSubcategoryName
ORDER BY
    Anio, Trimestre, VentasTotales DESC;

-- ============================================================
-- PREGUNTA B
-- ¿Que territorios generan mayor rentabilidad, y como se comparan
-- las ventas por Internet frente a Reseller en cada uno?
-- ============================================================

SELECT
    t.SalesTerritoryGroup    AS GrupoRegional,
    t.SalesTerritoryCountry  AS Pais,
    t.SalesTerritoryRegion   AS Region,
    'Internet'               AS Canal,
    SUM(f.SalesAmount)                      AS VentasTotales,
    SUM(f.TotalProductCost)                 AS CostoTotal,
    SUM(f.SalesAmount - f.TotalProductCost) AS GananciaBruta,
    ROUND(
        SUM(f.SalesAmount - f.TotalProductCost) /
        NULLIF(SUM(f.SalesAmount), 0) * 100, 2
    )                                       AS MargenPct,
    SUM(f.OrderQuantity)                    AS UnidadesVendidas
FROM FactInternetSales f
JOIN DimSalesTerritory t ON f.SalesTerritoryKey = t.SalesTerritoryKey
GROUP BY t.SalesTerritoryGroup, t.SalesTerritoryCountry, t.SalesTerritoryRegion

UNION ALL

SELECT
    t.SalesTerritoryGroup,
    t.SalesTerritoryCountry,
    t.SalesTerritoryRegion,
    'Reseller'               AS Canal,
    SUM(r.SalesAmount),
    SUM(r.TotalProductCost),
    SUM(r.SalesAmount - r.TotalProductCost),
    ROUND(
        SUM(r.SalesAmount - r.TotalProductCost) /
        NULLIF(SUM(r.SalesAmount), 0) * 100, 2
    ),
    SUM(r.OrderQuantity)
FROM FactResellerSales r
JOIN DimSalesTerritory t ON r.SalesTerritoryKey = t.SalesTerritoryKey
GROUP BY t.SalesTerritoryGroup, t.SalesTerritoryCountry, t.SalesTerritoryRegion

ORDER BY GananciaBruta DESC;

-- Vista pivotada (Internet vs Reseller por pais)
SELECT
    t.SalesTerritoryCountry AS Pais,
    t.SalesTerritoryGroup   AS Grupo,
    SUM(CASE WHEN canal = 'Internet'  THEN ventas ELSE 0 END) AS Ventas_Internet,
    SUM(CASE WHEN canal = 'Reseller'  THEN ventas ELSE 0 END) AS Ventas_Reseller,
    SUM(CASE WHEN canal = 'Internet'  THEN ganancia ELSE 0 END) AS Ganancia_Internet,
    SUM(CASE WHEN canal = 'Reseller'  THEN ganancia ELSE 0 END) AS Ganancia_Reseller
FROM (
    SELECT
        SalesTerritoryKey,
        'Internet' AS canal,
        SUM(SalesAmount) AS ventas,
        SUM(SalesAmount - TotalProductCost) AS ganancia
    FROM FactInternetSales
    GROUP BY SalesTerritoryKey
    UNION ALL
    SELECT
        SalesTerritoryKey,
        'Reseller',
        SUM(SalesAmount),
        SUM(SalesAmount - TotalProductCost)
    FROM FactResellerSales
    GROUP BY SalesTerritoryKey
) sub
JOIN DimSalesTerritory t ON sub.SalesTerritoryKey = t.SalesTerritoryKey
GROUP BY t.SalesTerritoryCountry, t.SalesTerritoryGroup
ORDER BY SUM(ganancia) DESC;

-- ============================================================
-- PREGUNTA C
-- ¿Cuales son los 10 productos mas rentables y como se distribuye
-- su venta a lo largo del tiempo (por año y trimestre)?
-- ============================================================

-- Paso 1: Identificar top 10 por ganancia bruta total
WITH Top10Productos AS (
    SELECT TOP 10
        p.ProductKey,
        p.EnglishProductName                      AS Producto,
        cat.EnglishProductCategoryName            AS Categoria,
        sub.EnglishProductSubcategoryName         AS Subcategoria,
        SUM(f.SalesAmount)                        AS VentasTotales,
        SUM(f.TotalProductCost)                   AS CostoTotal,
        SUM(f.SalesAmount - f.TotalProductCost)   AS GananciaBrutaTotal
    FROM FactInternetSales f
    JOIN DimProduct            p   ON f.ProductKey            = p.ProductKey
    JOIN DimProductSubcategory sub ON p.ProductSubcategoryKey = sub.ProductSubcategoryKey
    JOIN DimProductCategory    cat ON sub.ProductCategoryKey  = cat.ProductCategoryKey
    GROUP BY p.ProductKey, p.EnglishProductName,
             cat.EnglishProductCategoryName, sub.EnglishProductSubcategoryName
    ORDER BY GananciaBrutaTotal DESC
)
-- Paso 2: Distribucion trimestral de cada producto top 10
SELECT
    t.Producto,
    t.Categoria,
    t.Subcategoria,
    d.CalendarYear                           AS Anio,
    d.CalendarQuarter                        AS Trimestre,
    SUM(f.OrderQuantity)                     AS Unidades,
    SUM(f.SalesAmount)                       AS Ventas,
    SUM(f.SalesAmount - f.TotalProductCost)  AS GananciaBruta,
    t.GananciaBrutaTotal                     AS GananciaTotalProducto
FROM FactInternetSales f
JOIN DimDate    d ON f.OrderDateKey = d.DateKey
JOIN Top10Productos t ON f.ProductKey = t.ProductKey
GROUP BY t.Producto, t.Categoria, t.Subcategoria,
         d.CalendarYear, d.CalendarQuarter, t.GananciaBrutaTotal
ORDER BY t.GananciaBrutaTotal DESC, Anio, Trimestre;

-- Resumen rapido del Top 10 (para incluir en el PDF)
WITH Top10 AS (
    SELECT TOP 10
        p.EnglishProductName                    AS Producto,
        cat.EnglishProductCategoryName          AS Categoria,
        SUM(f.SalesAmount)                      AS Ventas,
        SUM(f.SalesAmount - f.TotalProductCost) AS GananciaBruta,
        ROUND(
            SUM(f.SalesAmount - f.TotalProductCost) /
            NULLIF(SUM(f.SalesAmount), 0) * 100, 1
        )                                       AS MargenPct
    FROM FactInternetSales f
    JOIN DimProduct            p   ON f.ProductKey            = p.ProductKey
    JOIN DimProductSubcategory sub ON p.ProductSubcategoryKey = sub.ProductSubcategoryKey
    JOIN DimProductCategory    cat ON sub.ProductCategoryKey  = cat.ProductCategoryKey
    GROUP BY p.EnglishProductName, cat.EnglishProductCategoryName
    ORDER BY GananciaBruta DESC
)
SELECT ROW_NUMBER() OVER (ORDER BY GananciaBruta DESC) AS Ranking,
       Producto, Categoria, Ventas, GananciaBruta, MargenPct
FROM Top10;
