# Global Sales Analytics – Data Engineering Case Study

This repository contains a reproducible data pipeline that integrates, cleans, and analyzes multi-region Salesforce data (North America & LATAM) using PostgreSQL and Python.

---

## 1 Environment Setup (Conda)

Create the environment from the provided `environment.yml` file:


conda env create -f environment.yml
conda activate sika-analytics

## 2 Database Setup & Data Load

1. Create a PostgreSQL database (e.g. `sika_db`)
2. Connect using `psql` or pgAdmin
3. Run the initial load script: \i sql/task_00_load_data.sql


## 3 Project Structure
.
├── environment.yml
├── csv/
│   ├──latam_lead.csv
│   ├──latam_opportunity.csv
│   ├──na_lead.csv
│   ├──na_opportunity.csv
├── sql/
│   ├── task_00_load_data.sql
│   ├── task_01_schema_integration/
│   ├── task_02_standardization/
│   ├── task_03_data_quality/
│   └── task_05_kpi_views/
│
├── notebooks/
│   └── 05_executive_analysis.ipynb
│
├── executive_summary.md
└── README.md

## 4 Analytics

Business KPIs are defined as SQL views

The Python notebook queries these KPI views directly

Visualizations and insights are produced in task_05_analytics.ipynb