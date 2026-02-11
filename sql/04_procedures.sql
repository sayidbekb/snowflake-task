USE DATABASE AIRLINE;
CREATE OR REPLACE PROCEDURE sp_load_harmonized_existing()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN

    -- Insert passengers
    INSERT INTO harmonized.dim_passenger (
        passenger_id,
        full_name,
        gender,
        age,
        nationality
    )
    SELECT DISTINCT
        passenger_id,
        first_name || ' ' || last_name,
        gender,
        age,
        nationality
    FROM airline.public.raw_passengers;

    -- Insert airports
    INSERT INTO harmonized.dim_airport (
        airport_name,
        airport_country_code,
        country_name,
        continent
    )
    SELECT DISTINCT
        airport_name,
        airport_country_code,
        country_name,
        airport_continent
    FROM airline.public.raw_passengers;

    -- Insert fact table
    INSERT INTO harmonized.fact_flight (
        passenger_sk,
        airport_sk,
        departure_date,
        arrival_airport,
        pilot_name,
        flight_status,
        ticket_type,
        passenger_status
    )
    SELECT
        p.passenger_sk,
        a.airport_sk,
        r.departure_date,
        r.arrival_airport,
        r.pilot_name,
        r.flight_status,
        r.ticket_type,
        r.passenger_status
    FROM airline.public.raw_passengers r
    JOIN harmonized.dim_passenger p
        ON r.passenger_id = p.passenger_id
    JOIN harmonized.dim_airport a
        ON r.airport_name = a.airport_name;

    -- Audit log
    INSERT INTO audit.load_log (process_name, rows_affected, run_ts)
    SELECT 'HARMONIZED_LOAD', COUNT(*), CURRENT_TIMESTAMP
    FROM airline.public.raw_passengers;

    RETURN 'EXISTING DATA LOAD COMPLETED';
END;
$$;




CREATE OR REPLACE PROCEDURE sp_load_analytics()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    CREATE OR REPLACE TABLE analytics.flight_summary AS
    SELECT
        departure_date,
        country_name,
        COUNT(*) AS total_passengers,
        COUNT_IF(ticket_type = 'Business') AS business_passengers
    FROM harmonized.fact_flight f
    JOIN harmonized.dim_airport a
        ON f.airport_sk = a.airport_sk
    GROUP BY departure_date, country_name;

    -- Fixed audit log
    INSERT INTO audit.load_log (process_name, rows_affected, run_ts)
    SELECT 'ANALYTICS_LOAD', COUNT(*), CURRENT_TIMESTAMP
    FROM analytics.flight_summary;

    RETURN 'ANALYTICS LOAD COMPLETED';
END;
$$;


