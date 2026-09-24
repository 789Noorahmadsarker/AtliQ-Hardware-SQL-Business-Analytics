# AtliQ Hardware — SQL Business Analytics

> An end-to-end SQL analytics project using MySQL to analyze financial performance, customer/product/market contribution, and supply-chain efficiency.

---

## 📌 Project Overview

AtliQ Hardware is a leading global manufacturer and distributor of computer hardware and electronic accessories.

The company sells a wide range of computer hardware and accessories through **retail, e-commerce, and direct sales channels** across multiple global markets.

To support data-driven decision-making, this project develops a **SQL-based analytical solution** to address key business requirements across **Finance Analytics, Top N Analysis, and Supply Chain Analytics**.

The project uses **MySQL** to transform raw transactional data into structured and reusable analytical solutions using **Functions, Views, Stored Procedures, CTEs, and Window Functions**.

---

## 🚀 Project Highlights

- 3 major business analytics domains
- 13 SQL-based analytical solutions
- Reusable **Views, Functions, and Stored Procedures**
- Dynamic **Top N Customers, Products, and Markets** analysis
- Regional customer-wise **Net Sales contribution** analysis
- Product ranking within each division
- Customer-level **Forecast Accuracy** analysis
- Actual vs Forecast data integration
- Practical application of **Window Functions** and advanced SQL techniques
- Stakeholder-driven approach to solving business problems

---

# 🎯 Business Problems

This project addresses three major business requirements.

## 1️⃣ Finance Analytics

The business needs a detailed monthly product-level sales report for **Croma India Customer for FY 2021** to track individual product sales and perform further product analytics in Excel.

The report should include:

- Month
- Product Name
- Variant
- Sold Quantity
- Gross Price Per Item
- Gross Price Total

The solution is then extended into a reusable **Stored Procedure**, allowing users to provide a customer and fiscal year dynamically.

An additional Stored Procedure determines the **Market Badge** based on total sold quantity:

- **Gold** → Total Sold Quantity > 5 Million
- **Silver** → Total Sold Quantity ≤ 5 Million

### Key SQL Concepts

- User-Defined Functions
- Joins
- Filtering
- Aggregation
- Stored Procedures
- Parameters
- Fiscal Year Analysis

---

# 2️⃣ Top N Analysis

The business needs flexible analytical reports to identify the **Top N Customers, Products, and Markets** for a selected fiscal year.

The value of **N** is user-defined, allowing users to generate Top 3, Top 5, Top 10, or other Top N reports.

## Net Sales Calculation

A reusable Net Sales calculation is developed through a sequence of SQL Views:

Pre-Invoice Sales
        ↓
Post-Invoice Sales
        ↓
Net Sales
        ↓
Top N Analysis

---

# 3️⃣ Supply Chain Analytics

The Product Owner needs an aggregate **Forecast Accuracy Report** for all customers for a given fiscal year to monitor the accuracy of the company's forecasts.

The report should include:

- Customer Code
- Customer Name
- Market
- Total Sold Quantity
- Total Forecast Quantity
- Absolute Error
- Forecast Accuracy %

---

## Actual vs Forecast Dataset

To perform the analysis, actual sales and forecast data are combined into a single analytical dataset.


fact_sales_monthly
        +
fact_forecast_monthly
        ↓
fact_act_est



## 🗂️ Project Structure


AtliQ-Hardware-SQL-Business-Analytics/
│
├── README.md
│
├── 01_Finance_Analytics/
│   ├── 01_fiscal_year_function.sql
│   ├── 02_croma_monthly_product_sales.sql
│   ├── 03_monthly_sales_stored_procedure.sql
│   └── 04_market_badge_stored_procedure.sql
│
├── 02_Top_N_Analysis/
│   ├── 01_sales_preinv_discount_view.sql
│   ├── 02_sales_postinv_discount_view.sql
│   ├── 03_net_sales_view.sql
│   ├── 04_top_n_markets.sql
│   ├── 05_top_n_customers.sql
│   ├── 06_customer_region_net_sales.sql
│   └── 07_top_n_products_by_division.sql
│
└── 03_Supply_Chain_Analytics/
    ├── 01_create_fact_act_est.sql
    └── 02_forecast_accuracy.sql
