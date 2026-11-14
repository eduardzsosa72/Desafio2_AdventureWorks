# Guía de Configuración del Cubo OLAP en Visual Studio (SSAS)

## Paso a paso para crear el cubo en Analysis Services

---

## 1. Crear el Proyecto en Visual Studio

1. Abrir Visual Studio
2. File → New → Project
3. Buscar: **Analysis Services Multidimensional and Data Mining Project**
4. Nombre del proyecto: `AdventureWorksCubo`
5. Click OK

---

## 2. Crear el Origen de Datos (Data Source)

1. Click derecho en "Data Sources" → New Data Source
2. Wizard: Next
3. Create a data source based on an existing or new connection → New
4. Provider: **SQL Server Native Client 11.0** (o Microsoft OLE DB)
5. Server name: tu nombre de servidor (ej: `localhost` o `.\SQLEXPRESS`)
6. Database: `AdventureWorksDW2022`
7. Test Connection → OK
8. Next → "Use the service account"
9. Name: `AdventureWorksDW2022` → Finish

---

## 3. Crear la Vista de Origen de Datos (DSV)

1. Click derecho en "Data Source Views" → New Data Source View
2. Seleccionar el origen creado → Next
3. **Tablas a incluir** (seleccionar todas estas):
   - FactInternetSales
   - FactResellerSales
   - DimDate
   - DimProduct
   - DimProductSubcategory
   - DimProductCategory
   - DimSalesTerritory
   - DimCustomer
   - DimReseller
4. Next → Name: `AdventureWorksDSV` → Finish

---

## 4. Definir las Dimensiones

Crear una dimensión por cada tabla dimensional:

### Dimensión: Date (Tiempo)
- Click derecho en "Dimensions" → New Dimension
- Use an existing table → Table: `DimDate`
- Key column: `DateKey`
- **Atributos a incluir**:
  - Calendar Year
  - Calendar Semester
  - Calendar Quarter
  - English Month Name
  - Full Date Alternate Key
- **Crear jerarquía**: 
  - Nombre: "Calendario"
  - Niveles: Calendar Year → Calendar Semester → Calendar Quarter → English Month Name

### Dimensión: Product (Producto)
- Table: `DimProduct`
- Key column: `ProductKey`
- **Atributos**: English Product Name, List Price, Standard Cost, Color, Size
- **Tablas relacionadas**: DimProductSubcategory, DimProductCategory
- **Crear jerarquía**:
  - Nombre: "Categorías de Producto"
  - Niveles: Category → Subcategory → Product Name

### Dimensión: Sales Territory (Territorio)
- Table: `DimSalesTerritory`
- Key column: `TerritoryKey`
- **Atributos**: Sales Territory Group, Sales Territory Country, Sales Territory Region
- **Crear jerarquía**:
  - Nombre: "Geografía de Ventas"
  - Niveles: Sales Territory Group → Sales Territory Country → Sales Territory Region

### Dimensión: Customer (Cliente)
- Table: `DimCustomer`
- Key column: `CustomerKey`
- **Atributos**: First Name, Last Name, English Education, English Occupation, Yearly Income

---

## 5. Crear el Cubo

1. Click derecho en "Cubes" → New Cube
2. Use existing tables
3. **Tablas de medidas**:
   - FactInternetSales
   - FactResellerSales
4. **Medidas a incluir**:

| Tabla | Medida | Nombre en cubo |
|---|---|---|
| FactInternetSales | SalesAmount | Internet Sales Amount |
| FactInternetSales | OrderQuantity | Internet Order Quantity |
| FactInternetSales | TotalProductCost | Internet Total Product Cost |
| FactResellerSales | SalesAmount | Reseller Sales Amount |
| FactResellerSales | OrderQuantity | Reseller Order Quantity |
| FactResellerSales | TotalProductCost | Reseller Total Product Cost |

5. **Agregar medidas calculadas** (en el Cube Designer → Calculations):

```mdx
-- Ganancia Bruta Internet
CREATE MEMBER CURRENTCUBE.[Measures].[Internet Gross Profit]
AS [Measures].[Internet Sales Amount] - [Measures].[Internet Total Product Cost],
FORMAT_STRING = "Currency",
VISIBLE = 1;

-- Ganancia Bruta Reseller
CREATE MEMBER CURRENTCUBE.[Measures].[Reseller Gross Profit]
AS [Measures].[Reseller Sales Amount] - [Measures].[Reseller Total Product Cost],
FORMAT_STRING = "Currency",
VISIBLE = 1;

-- Margen Internet (%)
CREATE MEMBER CURRENTCUBE.[Measures].[Internet Gross Profit Margin]
AS IIF([Measures].[Internet Sales Amount] = 0, NULL,
    ([Measures].[Internet Sales Amount] - [Measures].[Internet Total Product Cost])
    / [Measures].[Internet Sales Amount]),
FORMAT_STRING = "Percent",
VISIBLE = 1;

-- Ventas Totales (ambos canales)
CREATE MEMBER CURRENTCUBE.[Measures].[Total Sales Amount]
AS [Measures].[Internet Sales Amount] + [Measures].[Reseller Sales Amount],
FORMAT_STRING = "Currency",
VISIBLE = 1;
```

6. **Vincular dimensiones al cubo**:
   - Date → FactInternetSales (OrderDateKey → DateKey)
   - Date → FactResellerSales (OrderDateKey → DateKey)
   - Product → FactInternetSales y FactResellerSales (ProductKey)
   - Sales Territory → ambas tablas (SalesTerritoryKey)
   - Customer → FactInternetSales (CustomerKey)

---

## 6. Procesar el Cubo

1. Click derecho en el cubo → Process
2. Process Options: **Process Full**
3. Click Run
4. Esperar que aparezca: "Processing completed successfully"
5. Tomar captura de pantalla de este mensaje ✓

---

## 7. Verificar con MDX en SSMS

1. Abrir SSMS
2. Connect → Analysis Services → tu servidor
3. New Query → MDX
4. Ejecutar una consulta de prueba:

```mdx
SELECT 
    {[Measures].[Internet Sales Amount]} ON COLUMNS,
    {[Product].[Category].[Category].MEMBERS} ON ROWS
FROM [AdventureWorksCubo];
```

Si devuelve resultados, el cubo está funcionando correctamente ✓
