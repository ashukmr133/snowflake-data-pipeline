/* =========================================================
   1. FINAL TABLE (CLEAN DATA)
   ========================================================= */

CREATE OR REPLACE TABLE STU (
    ID INT,
    NAME VARCHAR(20),
    AGE INT,
    CITY VARCHAR(30)
);


/* =========================================================
   2. STAGE CREATION
   ========================================================= */

CREATE OR REPLACE STAGE STU_STG;

-- Check stage
SHOW STAGES;
LIST @STU_STG;


/* =========================================================
   3. STAGING TABLE (RAW DATA)
   ========================================================= */

CREATE OR REPLACE TABLE TEMP_STU (
    ID VARCHAR(20),
    NAME VARCHAR(20),
    AGE VARCHAR(20),
    CITY VARCHAR(30)
);


/* =========================================================
   4. FILE FORMAT
   ========================================================= */

CREATE OR REPLACE FILE FORMAT STU_FILE_FORMAT
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
NULL_IF = ('NULL','null','',' ')
TRIM_SPACE = TRUE;

-- Describe file format
DESC FILE FORMAT STU_FILE_FORMAT;


/* =========================================================
   5. CHECK FILES IN STAGE
   ========================================================= */

LIST @STU_STG;


/* =========================================================
   6. VALIDATE FILE (NO LOAD)
   ========================================================= */

COPY INTO TEMP_STU
FROM @STU_STG/qdaasasf.csv
FILE_FORMAT = STU_FILE_FORMAT
VALIDATION_MODE = 'RETURN_ERRORS';


/* =========================================================
   7. FIX FILE & RE-UPLOAD (MANUAL STEP)
   ========================================================= */

-- Remove old file
REMOVE @STU_STG/qdaasasf.csv;

-- Upload corrected file again (via UI or PUT)


/* =========================================================
   8. VALIDATE AGAIN
   ========================================================= */

COPY INTO TEMP_STU
FROM @STU_STG/qdaasasf.csv
FILE_FORMAT = STU_FILE_FORMAT
VALIDATION_MODE = 'RETURN_ERRORS';


/* =========================================================
   9. LOAD DATA INTO STAGING TABLE
   ========================================================= */

COPY INTO TEMP_STU
FROM @STU_STG
FILE_FORMAT = STU_FILE_FORMAT
ON_ERROR = 'CONTINUE'
FILES = ('qdaasasf.csv');

-- Check loaded data
SELECT * FROM TEMP_STU;


/* =========================================================
   10. TRANSFORM & LOAD INTO FINAL TABLE
   ========================================================= */

INSERT INTO STU
SELECT 
    TRY_TO_NUMBER(ID) AS ID,
    TRIM(NAME) AS NAME,
    TRY_TO_NUMBER(AGE) AS AGE,
    TRIM(SPLIT_PART(CITY, ',', 1)) AS CITY
FROM TEMP_STU
WHERE TRY_TO_NUMBER(ID) IS NOT NULL;


/* =========================================================
   11. FINAL VALIDATION
   ========================================================= */

SELECT * FROM STU;