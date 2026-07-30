# ✈️ Australian Airline Performance Analysis (2023–2026)

A comprehensive data analytics project exploring Australian domestic airline performance between **2023 and 2026** using **SQL Server** and **Power BI**.

The project demonstrates an end-to-end Business Intelligence workflow, including data cleaning, SQL data modelling, advanced analytical queries, and interactive Power BI dashboards for executive decision-making.

---

## 📌 Project Overview

This project analyses operational performance across Australian airlines, routes and airports using official flight performance data.

The objective was to transform raw operational data into meaningful business insights through SQL analysis and interactive Power BI visualisations.

The project answers questions such as:

- Which airlines have the highest on-time performance?
- Which routes experience the highest cancellation rates?
- Which airports perform best operationally?
- How has airline performance changed over time?
- Which operational trends can support better decision making?

---

## 🛠 Technologies Used

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- Power BI Desktop
- Git & GitHub

---

# 📂 Project Structure

```
Australian-Airline-Performance-Analysis
│
├── Data
│   └── airline_performance_2023_2026.csv
│
├── Raw Data
│   ├── OTP_Time_Series_Master_Current_april_2026.csv
│   └── OTP_Time_Series_Master_Current_april_2026.xlsx
│
├── SQL
│   ├── Clean_Data.sql
│   ├── Create_Table.sql
│   ├── Data_Table.sql
│   ├── PowerBI_Views.sql
│   ├── Analysis_Queries.sql
│   └── Advanced_Queries.sql
│
├── Power BI
│   └── Australia_Airline_Performance_Analysis_Dashboards.pbix
    └── Airline_And_Route_Analysis.png
    └── Airport_Operations_And_Trends.png
    └── Executive_Summary.png
│
├── Findings_Report.pdf
│
│
└── README.md
```

---

# 🗄 SQL Workflow

The project follows a structured SQL workflow.

### 1. Data Cleaning

- Removed unnecessary columns
- Standardised data types
- Removed duplicate records
- Prepared data for analysis

---

### 2. Database Creation

Created the SQL Server database and imported the cleaned dataset.

---

### 3. Analytical Views

Developed reusable SQL views including:

- Executive KPIs
- Airline Performance Summary
- Route Performance Summary
- Airport Arrival Performance
- Airport Departure Performance
- Monthly Performance Trends

These views were used directly by Power BI.

---

### 4. Analytical Queries

Created SQL queries to analyse:

- Airline rankings
- Airport performance
- Route performance
- Monthly trends
- Cancellation rates
- Operational KPIs

---

### 5. Advanced SQL

Implemented advanced SQL techniques including:

- Common Table Expressions (CTEs)
- Window Functions
- Ranking Functions
- Aggregate Analysis
- SQL Views
- Business KPI calculations

---

# 📊 Power BI Dashboards

## 1. Executive Overview

Provides a high-level summary of the Australian airline industry.

Features:

- Executive KPI cards
- Average Arrival OTP by Airline
- Cancellation Rate by Airline
- Monthly Arrival OTP Trend
- Scheduled Flights by Airline

---

## 2. Airline & Routes Analysis

Provides detailed airline and route level analysis.

Features:

- Top Performing Airlines
- Top Performing Routes
- Lowest Performing Routes
- Highest Cancellation Routes
- Detailed Route Performance Table

---

## 3. Airport Operations & Trends

Analyses airport operational performance.

Features:

- Top Departure Airports
- Top Arrival Airports
- Monthly Flight Volume
- Monthly Cancellation Trend
- Airport Performance Table

---

# 📈 Key Skills Demonstrated

### SQL

- Data Cleaning
- Database Design
- Views
- Aggregate Functions
- GROUP BY
- Window Functions
- Ranking Functions
- Common Table Expressions (CTEs)
- Business KPI Calculations

---

### Power BI

- Interactive Dashboards
- KPI Cards
- Bar Charts
- Line Charts
- Tables
- Slicers
- Conditional Formatting
- Data Modelling

---

### Data Analytics

- Data Cleaning
- Business Intelligence
- Performance Analysis
- Trend Analysis
- Executive Reporting
- Dashboard Design

---

# 📷 Dashboard 

See screenshots attached in the "Power BI" folder

---

# 📊 Dataset

The analysis is based on Australian domestic airline operational performance data covering **2023–2026**.

Metrics include:

- Scheduled Flights
- Flights Flown
- On-Time Performance (OTP)
- Arrival OTP
- Departure OTP
- Cancellation Rates
- Airlines
- Airports
- Routes

---

# 🎯 Project Outcomes

This project demonstrates an end-to-end Business Intelligence workflow from raw data through to executive reporting.

Key outcomes include:

- SQL data preparation and modelling
- Business KPI development
- Advanced SQL analysis
- Interactive Power BI dashboard design
- Executive-level reporting and visualisation

---

# 👤 Author

**Bohan Yang**

GitHub: https://github.com/Bohan0504

The dataset used in this project was obtained from:

https://www.bitre.gov.au/resource/aviation/airline-time-performance-monthly-reports-and-time-series-data

This was used for educational and portfolio purposes only.

---
