# Guía de Conexión y Dashboard en Power BI

---

## Paso 1: Conectar Power BI al Cubo OLAP

1. Abrir Power BI Desktop
2. Home → Get Data → More...
3. Buscar: **SQL Server Analysis Services database**
4. Connect
5. Server: `localhost` (o tu nombre de servidor)
6. Database (opcional): el nombre de tu cubo
7. Seleccionar **Connect live** (conexión en vivo, recomendado para OLAP)
8. OK → Navigator → expandir tu cubo → seleccionar las medidas/dimensiones → Load

---

## Paso 2: Estructura del Dashboard

Crear 3 páginas en Power BI, una por pregunta de negocio:

---

### PÁGINA 1: "Ventas por Categoría y Tiempo"
*(Pregunta A)*

**Visual 1 - Gráfico de barras apiladas**
- Eje X: Calendar Year
- Eje Y: Internet Sales Amount
- Leyenda: Category
- Título: "Ventas totales por categoría de producto y año"

**Visual 2 - Gráfico de líneas**
- Eje X: Calendar Quarter (todos los años combinados)
- Valores: Internet Sales Amount, Internet Order Quantity
- Leyenda: Category
- Título: "Tendencia trimestral de ventas por categoría"

**Visual 3 - Matriz**
- Filas: Category > Subcategory
- Columnas: Calendar Year > Calendar Quarter
- Valores: Internet Sales Amount
- Título: "Volumen de ventas: categoría × trimestre"

**Filtros de página**: Calendar Year (segmentador)

---

### PÁGINA 2: "Rentabilidad por Territorio"
*(Pregunta B)*

**Visual 1 - Mapa**
- Ubicación: Sales Territory Country
- Tamaño de burbuja: Total Sales Amount (Internet + Reseller)
- Color: Internet Gross Profit Margin
- Título: "Mapa de rentabilidad por país"

**Visual 2 - Gráfico de barras agrupadas**
- Eje Y: Sales Territory Country
- Valores: Internet Sales Amount (azul), Reseller Sales Amount (naranja)
- Orientación: horizontal
- Título: "Comparativa Canal Internet vs. Reseller por país"

**Visual 3 - Tabla**
- Columnas: País, Grupo Regional, Ventas Internet, Ganancia Internet,
           Ventas Reseller, Ganancia Reseller, Margen %
- Título: "Rentabilidad detallada por territorio y canal"

**Filtros de página**: Sales Territory Group (segmentador)

---

### PÁGINA 3: "Top 10 Productos Más Rentables"
*(Pregunta C)*

**Visual 1 - Gráfico de barras horizontales**
- Eje Y: Product (top 10 filtrado)
- Eje X: Internet Gross Profit
- Color: Subcategory
- Título: "Top 10 productos por ganancia bruta"
- Filtro: N superior → por Internet Gross Profit → Top 10

**Visual 2 - Gráfico de líneas**
- Eje X: Calendar Year + Calendar Quarter
- Valores: Internet Sales Amount
- Leyenda: Product (solo top 10)
- Título: "Evolución de ventas de los top 10 productos"

**Visual 3 - Heatmap / Matriz**
- Filas: Product (top 10)
- Columnas: Calendar Year > Calendar Quarter
- Valores: Internet Gross Profit (con formato condicional de color)
- Título: "Distribución trimestral de ganancia bruta — Top 10"

**Filtros de página**: Calendar Year (segmentador)

---

## Paso 3: Formato y presentación

- Tema del reporte: usar "Executive" o "Innovation" en Power BI
- Colores corporativos consistentes en todas las páginas
- Agregar el logo de Adventure Works en cada página (opcional)
- Título general del reporte en cada página: "Adventure Works — Dashboard de Ventas BI"
- Agregar cuadro de texto con la fecha del análisis y el nombre del autor

---

## Paso 4: Exportar para el PDF

Para cada visual:
1. Click derecho sobre el visual
2. "Export data" → guardar como imagen, O
3. Tomar captura de pantalla de la página completa del reporte
4. Incluir en la Sección 6 del PDF

---

## Consejo: Si Power BI no conecta directamente al cubo SSAS

Si tienes problemas de conexión en vivo:
1. Exportar los resultados de las consultas SQL a Excel
2. En Power BI: Get Data → Excel
3. Cargar las hojas y construir el mismo dashboard con datos tabulares
4. Esta alternativa es válida para el desafío
