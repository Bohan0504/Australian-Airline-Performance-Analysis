SELECT COUNT(*)
FROM dbo.CleanFlightPerformance;

SELECT TOP 10 *
FROM dbo.CleanFlightPerformance;

INSERT INTO dbo.CleanFlightPerformance (
    Route,
    DepartingPort,
    ArrivingPort,
    Airline,
    MonthText,
    FlightYear,
    FlightMonth,
    SectorsScheduled,
    SectorsFlown,
    Cancellations,
    DeparturesOnTime,
    ArrivalsOnTime,
    DeparturesDelayed,
    ArrivalsDelayed,
    OnTimeDeparturesPct,
    OnTimeArrivalsPct,
    CancellationPct
)
SELECT
    Route,
    Departing_Port,
    Arriving_Port,
    Airline,
    Month,
    2000 + TRY_CAST(RIGHT(Month, 2) AS INT) AS FlightYear,
    CASE LEFT(Month, 3)
        WHEN 'Jan' THEN 1
        WHEN 'Feb' THEN 2
        WHEN 'Mar' THEN 3
        WHEN 'Apr' THEN 4
        WHEN 'May' THEN 5
        WHEN 'Jun' THEN 6
        WHEN 'Jul' THEN 7
        WHEN 'Aug' THEN 8
        WHEN 'Sep' THEN 9
        WHEN 'Oct' THEN 10
        WHEN 'Nov' THEN 11
        WHEN 'Dec' THEN 12
    END AS FlightMonth,
    TRY_CAST(REPLACE(SectorsScheduled, ' ', '') AS INT),
    TRY_CAST(REPLACE(SectorsFlown, ' ', '') AS INT),
    TRY_CAST(REPLACE(Cancellations, ' ', '') AS INT),
    TRY_CAST(REPLACE(DeparturesOnTime, ' ', '') AS INT),
    TRY_CAST(REPLACE(ArrivalsOnTime, ' ', '') AS INT),
    TRY_CAST(REPLACE(DeparturesDelayed, ' ', '') AS INT),
    TRY_CAST(REPLACE(ArrivalsDelayed, ' ', '') AS INT),
    TRY_CAST(OnTimeDepartures AS DECIMAL(5,2)),
    TRY_CAST(OnTimeArrivals AS DECIMAL(5,2)),
    TRY_CAST(Cancellations1 AS DECIMAL(5,2))
FROM dbo.OTP_Time_Series_Master_Current_april_2026;