USE AirlinePerformance;
GO

-- =========================================================
-- Create Date Table for Power BI
-- Purpose: Supports year/month slicers and time-series analysis
-- =========================================================

DROP TABLE IF EXISTS dbo.DimDate;
GO

CREATE TABLE dbo.DimDate (
    DateKey INT PRIMARY KEY,
    MonthDate DATE,
    FlightYear INT,
    FlightMonth INT,
    MonthName NVARCHAR(20),
    MonthShort NVARCHAR(10),
    YearMonth NVARCHAR(20),
    QuarterName NVARCHAR(10),
    Season NVARCHAR(20)
);
GO

INSERT INTO dbo.DimDate (
    DateKey,
    MonthDate,
    FlightYear,
    FlightMonth,
    MonthName,
    MonthShort,
    YearMonth,
    QuarterName,
    Season
)
SELECT DISTINCT
    (FlightYear * 100) + FlightMonth AS DateKey,
    DATEFROMPARTS(FlightYear, FlightMonth, 1) AS MonthDate,
    FlightYear,
    FlightMonth,
    DATENAME(MONTH, DATEFROMPARTS(FlightYear, FlightMonth, 1)) AS MonthName,
    LEFT(DATENAME(MONTH, DATEFROMPARTS(FlightYear, FlightMonth, 1)), 3) AS MonthShort,
    CONCAT(FlightYear, '-', RIGHT('0' + CAST(FlightMonth AS VARCHAR(2)), 2)) AS YearMonth,
    CONCAT('Q', DATEPART(QUARTER, DATEFROMPARTS(FlightYear, FlightMonth, 1))) AS QuarterName,
    CASE
        WHEN FlightMonth IN (12, 1, 2) THEN 'Summer'
        WHEN FlightMonth IN (3, 4, 5) THEN 'Autumn'
        WHEN FlightMonth IN (6, 7, 8) THEN 'Winter'
        WHEN FlightMonth IN (9, 10, 11) THEN 'Spring'
    END AS Season
FROM dbo.CleanFlightPerformance;
GO

-- Check Date Table
SELECT *
FROM dbo.DimDate
ORDER BY MonthDate;
GO