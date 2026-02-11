USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;

-- Create db
CREATE OR REPLACE DATABASE AIRLINE;
USE DATABASE AIRLINE;

-- Create Schemas
CREATE OR REPLACE SCHEMA PUBLIC;
CREATE OR REPLACE SCHEMA AUDIT;


CREATE OR REPLACE TABLE PUBLIC.RAW_PASSENGERS (
    passenger_id STRING,
    first_name STRING,
    last_name STRING,
    gender STRING,
    age INTEGER,
    nationality STRING,
    airport_name STRING,
    airport_country_code STRING,
    country_name STRING,
    airport_continent STRING,
    continents STRING,
    departure_date STRING,
    arrival_airport STRING,
    pilot_name STRING,
    flight_status STRING,
    ticket_type STRING,
    passenger_status STRING,
    load_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);


-- FILE FORMAT
CREATE OR REPLACE FILE FORMAT CSV_FF
TYPE = CSV
FIELD_DELIMITER = ','
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
NULL_IF = ('', 'NULL')
ENCODING = 'UTF-8';


--AUDIT TABLE
CREATE OR REPLACE TABLE AUDIT.LOAD_LOG (
    process_name STRING,
    rows_affected NUMBER,
    run_ts TIMESTAMP
);