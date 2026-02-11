USE DATABASE AIRLINE;
CREATE OR REPLACE SCHEMA ANALYTICS;

CREATE OR REPLACE TABLE ANALYTICS.FLIGHT_SUMMARY AS
    SELECT
        departure_date,
        country_name,
        COUNT(*) AS total_passengers,
        COUNT_IF(ticket_type='Business') as business_passengers,
    FROM HARMONIZED.FACT_FLIGHT f
    JOIN HARMONIZED.DIM_AIRPORT a
        ON f.airport_sk = a.airport_sk
    GROUP BY departure_date, country_name;