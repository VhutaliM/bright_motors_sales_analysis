# bright_motors_sales_analysis

## 📌 Project Overview
This project is an end-to-end data analytics case study focused on analyzing car sales data for Bright Motors. 

The goal is to extract insights that can support business decisions related to sales performance, customer trends, and regional growth.
## Project Structure

| Folder | Description |
|---|---|
| 01_project_description_and_raw_data
| 02_project_planning 
| 03_data_processing 
| 04_project_presentation
---

## Dataset Access

The raw dataset is hosted externally due to GitHub file size limitations.

📁 Dataset Link:
https://docs.google.com/spreadsheets/d/1L9644i8FoyCKmK6TacvQAZEz3L0mw-O2/edit?usp=drive_link&ouid=117607412453058202108&rtpof=true&sd=true

This project focuses on cleaning, transforming, and visualizing car sales data using **Databricks SQL** and **Power BI**.

The project provides insights into:
- Total revenue generated
- Total cars sold
- Average selling price
- Revenue trends by state and month
- Top-performing car brands
- Vehicle pricing performance against market value

---

# 🛠️ Tools Used

- **Databricks SQL**
- **Power BI**

---

# 📂 Dataset Information

The dataset contains car sales information such as:

- Vehicle make and model
- Manufacturing year
- Selling price
- Market value (MMR)
- Mileage (odometer)
- Vehicle condition
- State/location
- Seller details
- Sales date

---

# 🧹 Data Cleaning

Data cleaning was performed in **Databricks SQL**.

### Cleaning Steps:
- Removed extra spaces using `TRIM()`
- Standardized text formatting using `INITCAP()`
- Converted columns into correct data types
- Fixed date formatting issues
- Handled null values
- Removed inconsistent/special characters
- Created a cleaned table for analysis

---

# ⚙️ Feature Engineering

New columns were created to improve analysis.

### Engineered Columns:
- `total_revenue`
- `units_sold`
- `price_difference`
- `price_difference_percentage`
- `car_age_at_sale`
- `sale_year`
- `sale_month_name`
- `sale_month_number`
- `sale_quarter`
- `mileage_category`
- `price_category`
- `price_performance`
- `condition_category`

---

# 📊 Dashboard Features

The Power BI dashboard includes:

## KPI Cards
- Total Revenue
- Total Cars Sold
- Average Selling Price

## Visualizations
- Top 10 Car Makes by Revenue
- Revenue by State
- Average Selling Price by Mileage Category
- Monthly Revenue Trend
- Market Value Performance

## Interactive Filters
- Make
- State
- Price Category

---

# 📈 Key Insights

- Ford generated the highest revenue among car brands
- Florida and California recorded strong sales performance
- Low mileage vehicles had higher average selling prices
- Most vehicles sold below market value
- Revenue trends varied significantly across months
