USE AirlinePerformance;
GO

DROP TABLE IF EXISTS dbo.CleanFlightPerformance;
GO

CREATE TABLE dbo.CleanFlightPerformance (
    FlightPerformanceID INT IDENTITY(1,1) PRIMARY KEY,
    Route NVARCHAR(100),
    DepartingPort NVARCHAR(50),
    ArrivingPort NVARCHAR(50),
    Airline NVARCHAR(50),
    MonthText NVARCHAR(20),
    FlightYear INT,
    FlightMonth INT,
    SectorsScheduled INT,
    SectorsFlown INT,
    Cancellations INT,
    DeparturesOnTime INT,
    ArrivalsOnTime INT,
    DeparturesDelayed INT,
    ArrivalsDelayed INT,
    OnTimeDeparturesPct DECIMAL(5,2),
    OnTimeArrivalsPct DECIMAL(5,2),
    CancellationPct DECIMAL(5,2)
);
GO