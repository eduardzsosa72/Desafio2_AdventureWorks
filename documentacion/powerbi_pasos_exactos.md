# Power BI Desktop — Pasos exactos para el Dashboard

## Conexión a SQL Server

1. Abrir Power BI Desktop
2. Click en **Obtener datos** → **SQL Server**
3. En "Servidor": `(localdb)\MSSQLLocalDB`
4. En "Base de datos": `AdventureWorksDW2022`
5. Click **Aceptar** → seleccionar **DirectQuery** o **Importar** (usar Importar)
6. En el Navegador, marcar estas tablas:
   - FactInternetSales
   - FactResellerSales
   - DimDate
   - DimProduct
   - DimProductSubcategory
   - DimProductCategory
   - DimSalesTerritory
7. Click **Cargar**

---

## Relaciones (si no se crean automáticamente)

Ir a Vista **Modelo** y verificar estas relaciones:
- FactInternetSales[OrderDateKey] → DimDate[DateKey]
- FactInternetSales[ProductKey] → DimProduct[ProductKey]
- FactInternetSales[SalesTerritoryKey] → DimSalesTerritory[SalesTerritoryKey]
- FactResellerSales[OrderDateKey] → DimDate[DateKey]
- FactResellerSales[ProductKey] → DimProduct[ProductKey]
- FactResellerSales[SalesTerritoryKey] → DimSalesTerritory[SalesTerritoryKey]
- DimProduct[ProductSubcategoryKey] → DimProductSubcategory[ProductSubcategoryKey]
- DimProductSubcategory[ProductCategoryKey] → DimProductCategory[ProductCategoryKey]

---

## Medidas DAX (crear en tabla nueva llamada "Medidas")

Ve a **Inicio** → **Nueva tabla** → nombrarla "Medidas", luego en ella crear:

```
Ventas Internet = SUM(FactInternetSales[SalesAmount])

Ventas Reseller = SUM(FactResellerSales[SalesAmount])

Costo Internet = SUM(FactInternetSales[TotalProductCost])

Costo Reseller = SUM(FactResellerSales[TotalProductCost])

Ganancia Internet = [Ventas Internet] - [Costo Internet]

Ganancia Reseller = [Ventas Reseller] - [Costo Reseller]

Ganancia Total = [Ganancia Internet] + [Ganancia Reseller]

Margen Internet % = DIVIDE([Ganancia Internet], [Ventas Internet], 0) * 100

Margen Reseller % = DIVIDE([Ganancia Reseller], [Ventas Reseller], 0) * 100

Unidades Internet = SUM(FactInternetSales[OrderQuantity])

Unidades Reseller = SUM(FactResellerSales[OrderQuantity])
```

---

## Página 1 — Pregunta A: Ventas por Categoría y Trimestre

**Título de la página:** "A — Ventas por Categoría y Subcategoría"

**Visulaes a crear:**

1. **Tarjetas (cards) en la parte superior:**
   - Tarjeta 1: Medida `Ventas Internet`
   - Tarjeta 2: Medida `Ganancia Internet`
   - Tarjeta 3: Medida `Margen Internet %`

2. **Gráfico de barras apiladas** (Stacked Bar Chart):
   - Eje Y: `DimProductCategory[EnglishProductCategoryName]`
   - Eje X: `Ventas Internet`
   - Leyenda: `DimDate[CalendarYear]`

3. **Gráfico de columnas** (Clustered Column):
   - Eje X: `DimDate[CalendarQuarter]`
   - Eje Y: `Ventas Internet`
   - Leyenda: `DimProductSubcategory[EnglishProductSubcategoryName]`

4. **Segmentador (Slicer)**:
   - Campo: `DimDate[CalendarYear]`

---

## Página 2 — Pregunta B: Rentabilidad por Territorio

**Título de la página:** "B — Rentabilidad por Territorio"

**Visuales a crear:**

1. **Tarjetas:**
   - Ganancia Internet
   - Ganancia Reseller
   - Ganancia Total

2. **Gráfico de barras agrupadas** (Clustered Bar):
   - Eje Y: `DimSalesTerritory[SalesTerritoryCountry]`
   - Valores: `Ganancia Internet` y `Ganancia Reseller` (dos barras por país)

3. **Gráfico de columnas apiladas** (Stacked Column):
   - Eje X: `DimSalesTerritory[SalesTerritoryGroup]`
   - Valores apilados: `Ventas Internet` + `Ventas Reseller`

4. **Segmentador:**
   - Campo: `DimSalesTerritory[SalesTerritoryGroup]`

---

## Página 3 — Pregunta C: Top 10 Productos

**Título de la página:** "C — Top 10 Productos Más Rentables"

**Visuales a crear:**

1. **Gráfico de barras horizontales** (Bar Chart):
   - Eje Y: `DimProduct[EnglishProductName]`
   - Eje X: `Ganancia Internet`
   - Filtro: Top N = 10 (en Filtros del panel → Tipo = N superior → 10 → por `Ganancia Internet`)

2. **Gráfico de líneas y columnas** (Line and Clustered Column):
   - Eje X: `DimDate[CalendarYear]` y `DimDate[CalendarQuarter]`
   - Columnas: `Ventas Internet`
   - Línea: `Margen Internet %`

3. **Tabla** con:
   - `DimProduct[EnglishProductName]`
   - `DimProductCategory[EnglishProductCategoryName]`
   - `Ventas Internet`
   - `Ganancia Internet`
   - `Margen Internet %`
   - Ordenar por Ganancia Internet descendente, mostrar solo top 10

---

## Guardar el archivo

Guardar como: `C:\Users\sosa\Documents\curso java\Desafio2_AdventureWorks\Dashboard_AdventureWorks.pbix`

Luego agregar al git:
```
git add Dashboard_AdventureWorks.pbix
git commit -m "feat: add Power BI dashboard"
git push
```
