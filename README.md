# snowflake-data-pipeline (Mini Project)
Built a robust Snowflake data pipeline to load, validate, and transform messy CSV data using staging tables, file formats, and COPY INTO with error handling.



## 📌 Overview

This project demonstrates a real-world data pipeline in Snowflake to handle messy CSV data.



## ⚙️ Tools Used

* Snowflake
* SQL
* CSV File Handling

## 📂 Pipeline Flow

1. Upload CSV to Stage
2. Define File Format
3. Load data into staging table
4. Clean and transform data
5. Insert into final table

## 🔧 Key Features

* Handles NULL values (`NULL`, `N/A`, empty)
* Handles invalid numeric data using `TRY_TO_NUMBER`
* Cleans city column using `SPLIT_PART`
* Uses `ON_ERROR = CONTINUE` for robust loading
* Uses `VALIDATION_MODE` for error detection

## 📊 Tables

* `TEMP_STU` → staging table
* `STU` → final clean table

## 🚀 Learning Outcome

* File format handling
* Staging concepts
* COPY INTO usage
* Data cleaning strategies



## 👨‍💻 Author

Ashutosh Kumar

Ashutosh

