USE AirlinePerformance;
GO

-- ============================================
-- View 1: Airline Performance Summary
-- For Power BI Dashboard Page 1
-- ============================================

DROP VIEW IF EXISTS dbo.vw_AirlinePerformanceSummary;
GO

CREATE VIEW dbo.vw_AirlinePerformanceSummary AS
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

-- ============================================
-- View 2: Monthly Performance Trend
-- For line charts in Power BI
-- ============================================

DROP VIEW IF EXISTS dbo.vw_MonthlyPerformanceTrend;
GO

CREATE VIEW dbo.vw_MonthlyPerformanceTrend AS
SELECT
    FlightYear,
    FlightMonth,
    DATEFROMPARTS(FlightYear, FlightMonth, 1) AS MonthDate,
    ROUND(AVG(OnTimeDeparturesPct), 2) AS AvgDepartureOTP,
    ROUND(AVG(OnTimeArrivalsPct), 2) AS AvgArrivalOTP,
    ROUND(AVG(CancellationPct), 2) AS AvgCancellationRate,
    SUM(SectorsScheduled) AS TotalScheduledFlights,
    SUM(SectorsFlown) AS TotalFlightsFlown,
    SUM(Cancellations) AS TotalCancellations
FROM dbo.CleanFlightPerformance
GROUP BY FlightYear, FlightMonth;
GO

-- ============================================
-- View 3: Route Performance Summary
-- For route-level analysis
-- ============================================

DROP VIEW IF EXISTS dbo.vw_RoutePerformanceSummary;
GO

CREATE VIEW dbo.vw_RoutePerformanceSummary AS
SELECT
    Route,
    DepartingPort,
    ArrivingPort,
    Airline,
    ROUND(AVG(OnTimeDeparturesPct), 2) AS AvgDepartureOTP,
    ROUND(AVG(OnTimeArrivalsPct), 2) AS AvgArrivalOTP,
    ROUND(AVG(CancellationPct), 2) AS AvgCancellationRate,
    SUM(SectorsScheduled) AS TotalScheduledFlights,
    SUM(SectorsFlown) AS TotalFlightsFlown,
    SUM(Cancellations) AS TotalCancellations,
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
GROUP BY
    Route,
    DepartingPort,
    ArrivingPort,
    Airline;
GO

-- ============================================
-- View 4: Airport Departure Performance
-- ============================================

DROP VIEW IF EXISTS dbo.vw_AirportDeparturePerformance;
GO

CREATE VIEW dbo.vw_AirportDeparturePerformance AS
SELECT
    DepartingPort,
    SUM(SectorsScheduled) AS TotalScheduledDepartures,
    SUM(SectorsFlown) AS TotalFlightsFlown,
    SUM(Cancellations) AS TotalCancellations,
    ROUND(AVG(OnTimeDeparturesPct), 2) AS AvgDepartureOTP,
    ROUND(AVG(CancellationPct), 2) AS AvgCancellationRate
FROM dbo.CleanFlightPerformance
GROUP BY DepartingPort;
GO

-- ============================================
-- View 5: Airport Arrival Performance
-- ============================================

DROP VIEW IF EXISTS dbo.vw_AirportArrivalPerformance;
GO

CREATE VIEW dbo.vw_AirportArrivalPerformance AS
SELECT
    ArrivingPort,
    ROUND(AVG(OnTimeArrivalsPct), 2) AS AvgArrivalOTP,
    ROUND(AVG(CancellationPct), 2) AS AvgCancellationRate,
    SUM(SectorsScheduled) AS TotalScheduledArrivals,
    SUM(SectorsFlown) AS TotalArrivalsFlown,
    SUM(Cancellations) AS TotalCancellations
FROM dbo.CleanFlightPerformance
GROUP BY ArrivingPort;
GO

-- ============================================
-- View 6: Summary KPIs
-- For Power BI card visuals
-- ============================================

DROP VIEW IF EXISTS dbo.vw_ExecutiveKPIs;
GO

CREATE VIEW dbo.vw_ExecutiveKPIs AS
SELECT
    COUNT(*) AS TotalRecords,
    SUM(SectorsScheduled) AS TotalScheduledFlights,
    SUM(SectorsFlown) AS TotalFlightsFlown,
    SUM(Cancellations) AS TotalCancellations,
    ROUND(AVG(OnTimeDeparturesPct), 2) AS OverallDepartureOTP,
    ROUND(AVG(OnTimeArrivalsPct), 2) AS OverallArrivalOTP,
    ROUND(AVG(CancellationPct), 2) AS OverallCancellationRate,
    COUNT(DISTINCT Airline) AS NumberOfAirlines,
    COUNT(DISTINCT Route) AS NumberOfRoutes
FROM dbo.CleanFlightPerformance;
GO

-- ============================================
-- View checks
-- ============================================

SELECT TOP 10 * FROM dbo.vw_AirlinePerformanceSummary;
SELECT TOP 10 * FROM dbo.vw_MonthlyPerformanceTrend;
SELECT TOP 10 * FROM dbo.vw_RoutePerformanceSummary;
SELECT TOP 10 * FROM dbo.vw_AirportDeparturePerformance;
SELECT TOP 10 * FROM dbo.vw_AirportArrivalPerformance;
SELECT * FROM dbo.vw_ExecutiveKPIs;
GO