USE DATABASE AIRLINE;
CREATE OR REPLACE SCHEMA HARMONIZED;
USE SCHEMA HARMONIZED;

-- DIMENSION TABLES
CREATE OR REPLACE TABLE DIM_PASSENGER (
    passenger_sk NUMBER AUTOINCREMENT,
    passenger_id STRING,
    full_name STRING,
    gender STRING,
    age NUMBER,
    nationality STRING
);

CREATE OR REPLACE TABLE DIM_AIRPORT (
    airport_sk NUMBER AUTOINCREMENT,
    airport_name STRING,
    airport_country_code STRING,
    country_name STRING,
    continent STRING
);


-- FACT TABLE



CREATE OR REPLACE TABLE FACT_FLIGHT (
    passenger_sk NUMBER,
    airport_sk NUMBER,
    departure_date DATE,
    arrival_airport STRING,
    pilot_name STRING,
    flight_status STRING,
    ticket_type STRING,
    passenger_status STRING
);
