# Desafío Práctico 2 — Datawarehouse y Minería de Datos (DMD 941)
## Universidad Don Bosco | Ing. Katherine Vigil

---

## Contenido del repositorio

```
Desafio2_AdventureWorks/
├── scripts/
│   ├── 01_exploracion_datos.sql      ← Exploración de tablas de hechos y dimensiones
│   └── 02_preguntas_negocio.sql      ← Consultas SQL para las 3 preguntas de negocio
├── mdx/
│   └── consultas_mdx.mdx             ← Consultas MDX sobre el cubo OLAP
├── documentacion/
│   ├── estructura_cubo_SSAS.md       ← Guía paso a paso para crear el cubo en Visual Studio
│   ├── guia_powerbi.md               ← Guía para conectar Power BI y construir el dashboard
│   └── analisis_gerencial.md         ← Análisis de datos (Sección 7 del PDF)
├── [Proyecto SSAS]                   ← Carpeta del proyecto de Analysis Services (Visual Studio)
├── [Dashboard.pbix]                  ← Archivo de Power BI
└── README.md                         ← Este archivo
```

---

## Pasos del proyecto

### 1. Restaurar la base de datos
- Descargar `AdventureWorksDW2022.bak` desde GitHub de Microsoft
- Restaurar en SQL Server Management Studio (SSMS)
- Verificar con: `SELECT name FROM sys.tables ORDER BY name;`

### 2. Explorar los datos
- Ejecutar `scripts/01_exploracion_datos.sql` en SSMS
- Identificar tablas de hechos y dimensiones relevantes

### 3. Crear el Cubo OLAP en Visual Studio
- Seguir la guía en `documentacion/estructura_cubo_SSAS.md`
- Herramienta: Visual Studio con SQL Server Analysis Services (SSAS)

### 4. Ejecutar consultas
- SQL: `scripts/02_preguntas_negocio.sql`
- MDX: `mdx/consultas_mdx.mdx` (desde SSMS conectado a Analysis Services)

### 5. Dashboard en Power BI
- Seguir la guía en `documentacion/guia_powerbi.md`
- Conectar al cubo OLAP y construir las 3 páginas del dashboard

---

## Preguntas de negocio respondidas

| # | Pregunta | Script SQL | Consulta MDX |
|---|---|---|---|
| A | Categorías/subcategorías por año y trimestre | `02_preguntas_negocio.sql` → Pregunta A | `consultas_mdx.mdx` → A1, A2, A3 |
| B | Rentabilidad por territorio: Internet vs Reseller | `02_preguntas_negocio.sql` → Pregunta B | `consultas_mdx.mdx` → B1, B2, B3 |
| C | Top 10 productos más rentables por año/trimestre | `02_preguntas_negocio.sql` → Pregunta C | `consultas_mdx.mdx` → C1, C2, C3 |

---

## Herramientas utilizadas
- SQL Server 2022 / SSMS
- Visual Studio 2022 + SQL Server Analysis Services (SSAS)
- Power BI Desktop
