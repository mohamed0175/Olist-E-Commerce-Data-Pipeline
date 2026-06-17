# E-Commerce End-to-End Data Engineering Platform

An end-to-end data engineering platform that automates the ingestion, programmatic sanitation, relational storage, and ETL orchestration of multi-domain retail records into a structured enterprise analytical data warehouse. 

This repository implements a production-grade data pipeline utilizing the authentic, real-world **Brazilian E-Commerce Public Dataset (by Olist)**. The pipeline models and processes diverse operational business domains—including customers, sellers, products, orders, operational reviews, payments, and geospatial coordinates—transforming chaotic raw transactions into optimized business intelligence assets.

---

## 🏗️ System Architecture

The project enforces a highly decoupled, layered data engineering workflow to isolate processing concerns, guarantee schema enforceability, and optimize analytical query speeds.

1. **Ingestion & Data Munging Layer:** Raw, unstructured CSV files are programmatically normalized and scrubbed.
2. **Operational Data Store (ODS):** Cleaned datasets are mapped into a strictly relational OLTP schema to ensure transactional integrity.
3. **ETL Orchestration Layer:** Data is systematically extracted from the OLTP source, evaluated against warehouse keys, and systematically routed.
4. **Analytical Storage Layer (OLAP):** High-speed multi-dimensional Star Schema that minimizes execution overhead for analytical workloads.
5. **Presentation Layer:** Semantic reporting dashboard connected directly to the warehouse for interactive stakeholder exploration.

---

## ⚙️ Core Pipeline Lifecycle

### 1. Programmatic Preprocessing (Python & Pandas)
To resolve structural vulnerabilities common in public datasets, an isolated Python scripting layer acts as the initial data gateway. Key cleansing matrices include:
* **Null & Missing Value Resolution:** Systematically isolates empty fields across datasets, applying business-rule defaults to preserve row completeness.
* **De-duplication Routines:** Purges redundant entries to prevent synthetic metric inflation down the pipeline.
* **Strict Type Casting:** Enforces explicit data types (e.g., forcing numerical precision standards and stripping string constraints).
* **Temporal Parsing:** Standardizes multi-format time strings into strict ISO timestamp metrics, enabling precise time-series indexing.

### 2. Operational Database Layer (OLTP - `Ecommerce_OLTP`)
Sanitized tables are bulk-loaded into a centralized Microsoft SQL Server relational instance.
* Designed according to Normalized Schema standards to eliminate operational operational update anomalies.
* Configured with explicit Primary and Foreign Key constraints to maintain rigid system-wide referential validation across business domains.
* Built as a high-availability staging target designed to supply pure relational data to down-stream pipelines.

### 3. ETL Pipeline Integration (SSIS)
Data extraction, transformation processing, and target mapping are executed via modular **SQL Server Integration Services (SSIS)** control blocks:
* **`DimProduct` Ingestion:** Isolates product catalog properties, maps categories, and synchronizes the product dimension.
* **`DimSeller` Ingestion:** Parses seller geographical distribution networks into a unified lookup array.
* **`DimCustomer` Ingestion:** Structures unique consumer identity traces across distinct regional boundaries.
* **`DimOrderReview` Ingestion:** Aggregates qualitative customer feedback scores and review metrics.
* **`FactOrders` Ingestion:** The terminal processing stage that executes lookup operations to join raw operational logs against warehouse surrogate keys, populating the central fact repository.

### 4. Analytical Warehousing (OLAP - `EcommerceDWH`)
The reporting layer utilizes a **Kimball Star Schema** optimization layout, dropping messy operational execution costs in favor of lightning-fast column scanning:
* **Fact Table (`FactOrders`):** Captures individual sales metrics, storing core quantitative measures (quantities, prices, operational fees) and transaction pointers.
* **Dimension Tables:** Surrounds the core transactions with deep contextual lookups, housing `DimProduct`, `DimSeller`, `DimCustomer`, `DimOrderReview`, and a pre-calculated conformed `DimDate` dimension.

### 5. Semantic Visualization (Power BI)
A live connection binds the Power BI reporting engine directly to the `EcommerceDWH` instance, exposing critical performance insights:
* **Revenue Performance Dynamics:** Line and area charts tracking overall gross income trends mapped against chronological timelines.
* **Product Performance Evaluation:** Bar charts analyzing sales velocities across specific product categories.
* **Customer Sentiment Analysis:** Aggregated review score track lines to flag regional logistics friction.
* **Geographical Sales Distribution:** Spatial distribution heat-mapping to spotlight high-density consumer spending markets.
* **Dynamic Slicers:** Full dashboard parameterization allowing business leaders to filter execution data by Year, State, and Product Segment seamlessly.

---

## 💻 Technical Infrastructure Stack

* **Programming Languages:** Python (Pandas framework for programmatic data munging).
* **Database Management Systems:** Microsoft SQL Server (OLTP relational instance and OLAP data warehouse).
* **Data Orchestration Platform:** SQL Server Integration Services (SSIS).
* **Reporting & BI Canvas:** Power BI Desktop.
* **Architecture Methodology:** Kimball Dimensional Star Schema Modeling.

---

## 🛠️ Engineering Challenges & Resolutions

* **Challenge: Corrupted Source Schemas.** Raw public retail records contained highly inconsistent string formats, missing blocks, and malformed arrays.
  * **Resolution:** Engineered a localized Python cleaning pipeline that validates every data point against specific data types before loading into the database.
* **Challenge: Missing Referential Links.** Connecting disparate public operational records threatened to drop rows due to foreign key violations.
  * **Resolution:** Implemented advanced physical data adjustments and customized structural mapping rules to reconcile orphan records while preserving data lineage.
* **Challenge: Fact Table Execution Failures.** Fact tables regularly dropped incoming keys when parent dimension packages failed to finish loading in time.
  * **Resolution:** Structured strict precedence constraints within the SSIS control flow environment, guaranteeing that all dimension dependencies complete execution successfully before the fact table begins ingestion.

---

## 🚀 Future Roadmap

* **Orchestration Automation:** Implement automated SQL Server Agent Jobs to schedule the pipeline during off-peak operational hours.
* **Cloud Platform Migration:** Transition database instances and SSIS execution packages to cloud environments like Microsoft Azure Data Factory or Amazon Web Services (AWS).
* **Incremental Processing (CDC):** Upgrade truncate-and-load routines to Change Data Capture architectures to ingest daily transactional updates efficiently.
* **Automated Data Quality Gates:** Integrate continuous validation testing checks within individual ETL execution pipelines to isolate anomaly flags automatically.
