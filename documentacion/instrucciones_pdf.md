# Instrucciones para el PDF del Desafío Práctico 2

## Secciones del PDF y capturas requeridas

---

### Sección 1 — Portada
- Nombre: Eduardo Sosa
- Carrera / Materia: DMD 941 — Datawarehouse y Minería de Datos
- Docente: Ing. Katherine Vigil
- Universidad Don Bosco
- Fecha de entrega: Noviembre 2026

---

### Sección 2 — Restauración de la base de datos

**Captura requerida:** SSMS mostrando la base de datos `AdventureWorksDW2022` en el Explorador de objetos con las tablas visibles.

Pasos para abrir SSMS:
1. Conectar a `(localdb)\MSSQLLocalDB`
2. Expandir Bases de datos → AdventureWorksDW2022 → Tablas

---

### Sección 3 — Exploración de datos

**Captura requerida:** SSMS ejecutando `scripts/01_exploracion_datos.sql` con resultados visibles.

1. Abrir SSMS → Nueva consulta
2. Abrir y ejecutar `01_exploracion_datos.sql`
3. Capturar pantalla con la consulta y los resultados

---

### Sección 4 — Consultas SQL para las 3 preguntas de negocio

Para cada pregunta, captura la consulta ejecutada y los primeros resultados.

**Pregunta A** — Categorías y subcategorías por año/trimestre:
- Abrir `02_preguntas_negocio.sql`
- Ejecutar el bloque de PREGUNTA A (líneas 17-40)
- Capturar pantalla

**Pregunta B** — Rentabilidad por territorio Internet vs Reseller:
- Ejecutar el bloque PREGUNTA B (líneas 48-113)
- Capturar pantalla

**Pregunta C** — Top 10 productos más rentables:
- Ejecutar el bloque PREGUNTA C (líneas 122-177)
- Capturar pantalla

---

### Sección 5 — Cubo OLAP en Visual Studio (SSAS)

**Capturas requeridas:**

1. **Explorador de soluciones** completo mostrando:
   - Orígenes de datos: AdventureWorksDW2022.ds
   - Vistas del origen de datos: AdventureWorksDW2022.dsv
   - Cubos: VentasAdventureWorks.cube
   - Dimensiones: DimDate.dim, DimProduct.dim, DimSalesTerritory.dim, DimCustomer.dim

2. **Diseñador de dimensión** (haz doble clic en DimDate.dim o DimProduct.dim):
   - Muestra los atributos y la jerarquía Categoría → Subcategoría → Producto

3. **Lista de errores con 0 errores** (ya visible en la barra inferior de VS)

---

### Sección 6 — Consultas MDX

**Capturas:** Abrir el archivo `mdx/consultas_mdx.mdx` y capturar el contenido (si no tienes SSAS server, solo captura el archivo en VS Code o Notepad)

Las consultas MDX están documentadas para el cubo `Adventure Works`:
- A1: Ventas por categoría y trimestre
- A2: Ranking de subcategorías
- A3: Variación anual
- B1: Rentabilidad por territorio
- B2: Internet vs Reseller por región
- B3: Top territorios por ganancia
- C1: Top 10 productos por ganancia
- C2: Distribución trimestral de top 10
- C3: Comparativa categorías

---

### Sección 7 — Dashboard Power BI

**Capturas:** 3 páginas del dashboard (ver sección separada)

---

### Sección 8 — Repositorio GitHub

**Captura:** Pantalla de GitHub mostrando el repositorio `Desafio2_AdventureWorks` con los archivos subidos.

URL del repositorio: `https://github.com/eduardzsosa72/Desafio2_AdventureWorks`

---

### Sección 9 — Análisis gerencial

Ver documento completo en `documentacion/analisis_gerencial.md`

**Resumen:**
- Categoría Bikes domina con 95% de las ventas
- North America es el territorio más rentable
- Mountain-200 Black es el producto top con mayor ganancia bruta

---

## Herramienta recomendada para el PDF

Usa **Microsoft Word** o **Google Docs**:
1. Pega cada captura de pantalla en la sección correspondiente
2. Agrega el título de cada sección
3. Exporta como PDF
