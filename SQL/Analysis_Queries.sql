-- =========================================================
-- Australian Airline Performance Analysis
-- File: Analysis_Queries.sql
-- Purpose: Analyse airline reliability, cancellations,
--          route performance, and airport-level trends.
-- =========================================================

SELECT
    Airline,
    ROUND(AVG(OnTimeDeparturesPct), 2) AS AvgDepartureOTP,
    ROUND(AVG(OnTimeArrivalsPct), 2) AS AvgArrivalOTP,
    ROUND(AVG(CancellationPct), 2) AS AvgCancellationRate,
    SUM(SectorsScheduled) AS TotalScheduledFlights
FROM dbo.CleanFlightPerformance
GROUP BY Airline
ORDER BY AvgArrivalOTP DESC;

-- Airline Ranking by Year
SELECT
    FlightYear,
    Airline,
    ROUND(AVG(OnTimeArrivalsPct),2) AS AvgArrivalOTP
FROM dbo.CleanFlightPerformance
GROUP BY FlightYear, Airline
ORDER BY FlightYear, AvgArrivalOTP DESC;

-- Best Routes 
SELECT TOP 10
    Route,
    Airline,
    ROUND(AVG(OnTimeArrivalsPct),2) AS AvgArrivalOTP
FROM dbo.CleanFlightPerformance
GROUP BY Route, Airline
ORDER BY AvgArrivalOTP DESC;

-- Worst Routes
SELECT TOP 10
    Route,
    Airline,
    ROUND(AVG(CancellationPct),2) AS AvgCancellationRate
FROM dbo.CleanFlightPerformance
GROUP BY Route, Airline
ORDER BY AvgCancellationRate DESC;

-- Busiest Airports
SELECT
    DepartingPort,
    SUM(SectorsScheduled) AS TotalFlights
FROM dbo.CleanFlightPerformance
GROUP BY DepartingPort
ORDER BY TotalFlights DESC;