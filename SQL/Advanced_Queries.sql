-- =========================================================
-- Australian Airline Performance Analysis
-- File: 04_Advanced_Analysis.sql
-- Purpose: Advanced SQL analysis using views, CTEs,
--          ranking functions, trend analysis and filtering.
-- =========================================================

USE AirlinePerformance;
GO

-- =========================================================
-- 1. CREATE VIEW: Airline Performance Summary
-- =========================================================

DROP VIEW IF EXISTS dbo.vw_AirlinePerformance;
GO

CREATE VIEW dbo.vw_AirlinePerformance AS
SELECT
    Airline,
    ROUND(AVG(OnTimeDeparturesPct), 2) AS AvgDepartureOTP,
    ROUND(AVG(OnTimeArrivalsPct), 2) AS AvgArrivalOTP,
    ROUND(AVG(CancellationPct), 2) AS AvgCancellationRate,
    SUM(SectorsScheduled) AS TotalScheduledFlights,
    SUM(SectorsFlown) AS TotalFlightsFlown,
    SUM(Cancellations) AS TotalCancellations
FROM dbo.CleanFlightPerformance
GROUP BY Airline;
GO

-- View check
SELECT *
FROM dbo.vw_AirlinePerformance
ORDER BY AvgArrivalOTP DESC;
GO

-- =========================================================
-- 2. AIRLINE RANKING USING RANK()
-- =========================================================

SELECT
    Airline,
    AvgDepartureOTP,
    AvgArrivalOTP,
    AvgCancellationRate,
    TotalScheduledFlights,
    RANK() OVER (ORDER BY AvgArrivalOTP DESC) AS ArrivalOTPRank,
    RANK() OVER (ORDER BY AvgCancellationRate ASC) AS CancellationRank
FROM dbo.vw_AirlinePerformance
ORDER BY ArrivalOTPRank;
GO

-- =========================================================
-- 3. AIRLINE PERFORMANCE BY YEAR
-- =========================================================

SELECT
    FlightYear,
    Airline,
    ROUND(AVG(OnTimeDeparturesPct), 2) AS AvgDepartureOTP,
    ROUND(AVG(OnTimeArrivalsPct), 2) AS AvgArrivalOTP,
    ROUND(AVG(CancellationPct), 2) AS AvgCancellationRate,
    SUM(SectorsScheduled) AS TotalScheduledFlights
FROM dbo.CleanFlightPerformance
GROUP BY FlightYear, Airline
ORDER BY Airline, FlightYear;
GO

-- =========================================================
-- 4. YEAR-OVER-YEAR AIRLINE PERFORMANCE CHANGE
-- =========================================================

WITH YearlyAirlinePerformance AS (
    SELECT
        FlightYear,
        Airline,
        ROUND(AVG(OnTimeArrivalsPct), 2) AS AvgArrivalOTP
    FROM dbo.CleanFlightPerformance
    GROUP BY FlightYear, Airline
),
PerformanceChange AS (
    SELECT
        Airline,
        FlightYear,
        AvgArrivalOTP,
        LAG(AvgArrivalOTP) OVER (
            PARTITION BY Airline
            ORDER BY FlightYear
        ) AS PreviousYearOTP
    FROM YearlyAirlinePerformance
)
SELECT
    Airline,
    FlightYear,
    AvgArrivalOTP,
    PreviousYearOTP,
    ROUND(AvgArrivalOTP - PreviousYearOTP, 2) AS YearlyChange
FROM PerformanceChange
WHERE PreviousYearOTP IS NOT NULL
ORDER BY Airline, FlightYear;
GO

-- =========================================================
-- 5. MOST IMPROVED AIRLINES BETWEEN 2023 AND 2026
-- =========================================================

WITH AirlineYearComparison AS (
    SELECT
        Airline,
        FlightYear,
        ROUND(AVG(OnTimeArrivalsPct), 2) AS AvgArrivalOTP
    FROM dbo.CleanFlightPerformance
    WHERE FlightYear IN (2023, 2026)
    GROUP BY Airline, FlightYear
),
PivotedPerformance AS (
    SELECT
        Airline,
        MAX(CASE WHEN FlightYear = 2023 THEN AvgArrivalOTP END) AS OTP_2023,
        MAX(CASE WHEN FlightYear = 2026 THEN AvgArrivalOTP END) AS OTP_2026
    FROM AirlineYearComparison
    GROUP BY Airline
)
SELECT
    Airline,
    OTP_2023,
    OTP_2026,
    ROUND(OTP_2026 - OTP_2023, 2) AS OTP_Improvement
FROM PivotedPerformance
WHERE OTP_2023 IS NOT NULL
  AND OTP_2026 IS NOT NULL
ORDER BY OTP_Improvement DESC;
GO

-- =========================================================
-- 6. BUSIEST ROUTES BY SCHEDULED FLIGHTS
-- =========================================================

SELECT TOP 10
    Route,
    SUM(SectorsScheduled) AS TotalScheduledFlights,
    SUM(SectorsFlown) AS TotalFlightsFlown,
    ROUND(AVG(OnTimeArrivalsPct), 2) AS AvgArrivalOTP,
    ROUND(AVG(CancellationPct), 2) AS AvgCancellationRate
FROM dbo.CleanFlightPerformance
GROUP BY Route
ORDER BY TotalScheduledFlights DESC;
GO

-- =========================================================
-- 7. WORST ROUTES BY CANCELLATION RATE
-- Minimum flight threshold added to avoid tiny sample sizes.
-- =========================================================

SELECT TOP 10
    Route,
    Airline,
    SUM(SectorsScheduled) AS TotalScheduledFlights,
    SUM(Cancellations) AS TotalCancellations,
    ROUND(AVG(CancellationPct), 2) AS AvgCancellationRate
FROM dbo.CleanFlightPerformance
GROUP BY Route, Airline
HAVING SUM(SectorsScheduled) > 1000
ORDER BY AvgCancellationRate DESC;
GO

-- =========================================================
-- 8. MOST RELIABLE ROUTES BY ARRIVAL OTP
-- Minimum flight threshold added to avoid tiny sample sizes.
-- =========================================================

SELECT TOP 10
    Route,
    Airline,
    SUM(SectorsScheduled) AS TotalScheduledFlights,
    ROUND(AVG(OnTimeArrivalsPct), 2) AS AvgArrivalOTP,
    ROUND(AVG(CancellationPct), 2) AS AvgCancellationRate
FROM dbo.CleanFlightPerformance
GROUP BY Route, Airline
HAVING SUM(SectorsScheduled) > 1000
ORDER BY AvgArrivalOTP DESC;
GO

-- =========================================================
-- 9. AIRPORT DEPARTURE PERFORMANCE
-- =========================================================

SELECT
    DepartingPort,
    SUM(SectorsScheduled) AS TotalScheduledDepartures,
    SUM(SectorsFlown) AS TotalFlightsFlown,
    SUM(Cancellations) AS TotalCancellations,
    ROUND(AVG(OnTimeDeparturesPct), 2) AS AvgDepartureOTP,
    ROUND(AVG(CancellationPct), 2) AS AvgCancellationRate,
    RANK() OVER (
        ORDER BY AVG(OnTimeDeparturesPct) DESC
    ) AS DeparturePerformanceRank
FROM dbo.CleanFlightPerformance
GROUP BY DepartingPort
ORDER BY DeparturePerformanceRank;
GO

-- =========================================================
-- 10. AIRPORT ARRIVAL PERFORMANCE
-- =========================================================

SELECT
    ArrivingPort,
    SUM(SectorsScheduled) AS TotalScheduledArrivals,
    ROUND(AVG(OnTimeArrivalsPct), 2) AS AvgArrivalOTP,
    ROUND(AVG(CancellationPct), 2) AS AvgCancellationRate,
    RANK() OVER (
        ORDER BY AVG(OnTimeArrivalsPct) DESC
    ) AS ArrivalPerformanceRank
FROM dbo.CleanFlightPerformance
GROUP BY ArrivingPort
ORDER BY ArrivalPerformanceRank;
GO

-- =========================================================
-- 11. MONTHLY PERFORMANCE TREND
-- =========================================================

SELECT
    FlightYear,
    FlightMonth,
    ROUND(AVG(OnTimeDeparturesPct), 2) AS AvgDepartureOTP,
    ROUND(AVG(OnTimeArrivalsPct), 2) AS AvgArrivalOTP,
    ROUND(AVG(CancellationPct), 2) AS AvgCancellationRate,
    SUM(SectorsScheduled) AS TotalScheduledFlights
FROM dbo.CleanFlightPerformance
GROUP BY FlightYear, FlightMonth
ORDER BY FlightYear, FlightMonth;
GO

-- =========================================================
-- 12. SEASONAL PERFORMANCE ANALYSIS
-- =========================================================

SELECT
    CASE
        WHEN FlightMonth IN (12, 1, 2) THEN 'Summer'
        WHEN FlightMonth IN (3, 4, 5) THEN 'Autumn'
        WHEN FlightMonth IN (6, 7, 8) THEN 'Winter'
        WHEN FlightMonth IN (9, 10, 11) THEN 'Spring'
    END AS Season,
    ROUND(AVG(OnTimeDeparturesPct), 2) AS AvgDepartureOTP,
    ROUND(AVG(OnTimeArrivalsPct), 2) AS AvgArrivalOTP,
    ROUND(AVG(CancellationPct), 2) AS AvgCancellationRate,
    SUM(SectorsScheduled) AS TotalScheduledFlights
FROM dbo.CleanFlightPerformance
GROUP BY
    CASE
        WHEN FlightMonth IN (12, 1, 2) THEN 'Summer'
        WHEN FlightMonth IN (3, 4, 5) THEN 'Autumn'
        WHEN FlightMonth IN (6, 7, 8) THEN 'Winter'
        WHEN FlightMonth IN (9, 10, 11) THEN 'Spring'
    END
ORDER BY AvgArrivalOTP DESC;
GO

-- =========================================================
-- 13. AIRLINE CANCELLATION CATEGORY
-- Uses CASE to classify airline cancellation performance.
-- =========================================================

SELECT
    Airline,
    ROUND(AVG(CancellationPct), 2) AS AvgCancellationRate,
    CASE
        WHEN AVG(CancellationPct) < 2 THEN 'Low Cancellation Risk'
        WHEN AVG(CancellationPct) BETWEEN 2 AND 5 THEN 'Moderate Cancellation Risk'
        ELSE 'High Cancellation Risk'
    END AS CancellationRiskCategory
FROM dbo.CleanFlightPerformance
GROUP BY Airline
ORDER BY AvgCancellationRate DESC;
GO

-- =========================================================
-- 14. ROUTES WITH HIGH DELAY AND HIGH CANCELLATION RISK
-- =========================================================

SELECT
    Route,
    Airline,
    ROUND(AVG(OnTimeArrivalsPct), 2) AS AvgArrivalOTP,
    ROUND(AVG(CancellationPct), 2) AS AvgCancellationRate,
    SUM(SectorsScheduled) AS TotalScheduledFlights,
    CASE
        WHEN AVG(OnTimeArrivalsPct) < 65
             AND AVG(CancellationPct) > 5
        THEN 'High Risk Route'
        WHEN AVG(OnTimeArrivalsPct) < 75
             OR AVG(CancellationPct) > 3
        THEN 'Moderate Risk Route'
        ELSE 'Reliable Route'
    END AS RouteRiskCategory
FROM dbo.CleanFlightPerformance
GROUP BY Route, Airline
HAVING SUM(SectorsScheduled) > 1000
ORDER BY AvgCancellationRate DESC, AvgArrivalOTP ASC;
GO

-- =========================================================
-- 15. SUMMARY KPIs FOR POWER BI
-- Useful for dashboard cards.
-- =========================================================

SELECT
    COUNT(*) AS TotalRecords,
    SUM(SectorsScheduled) AS TotalScheduledFlights,
    SUM(SectorsFlown) AS TotalFlightsFlown,
    SUM(Cancellations) AS TotalCancellations,
    ROUND(AVG(OnTimeDeparturesPct), 2) AS OverallDepartureOTP,
    ROUND(AVG(OnTimeArrivalsPct), 2) AS OverallArrivalOTP,
    ROUND(AVG(CancellationPct), 2) AS OverallCancellationRate
FROM dbo.CleanFlightPerformance;
GO