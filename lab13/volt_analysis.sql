create table dbo.VoltageRMSMeasurement
(
    SessionID     bigint        not null,
    StartInterval datetime2(3)  not null,
    Phase         tinyint       not null, -- 1=L1, 2=L2, 3=L3, 4=N, 5=PE
    RMSVoltage    decimal(9, 3) not null,
    constraint PK_VoltageRMSMeasurement primary key (SessionID, StartInterval, Phase),
    constraint FK_VoltageRMS_Session foreign key (SessionID) references dbo.MeasurementSession (SessionID)
);

create index IDX_VoltageRMS_Session_Interval on dbo.VoltageRMSMeasurement (SessionID, StartInterval, Phase) include (RMSVoltage);
go

CREATE TABLE dbo.SystemParameter
(
    ParameterName   NVARCHAR(50)   NOT NULL  PRIMARY KEY,
    ParameterValue  DECIMAL(14,4)  NOT NULL
);

create view dbo.View_VoltageCompliance as
    select loc.LocationID,
           dateadd(day, - (datepart(weekday, rm.StartInterval) + 5) % 7, cast(rm.StartInterval as date)) as PeriodStart,
           dateadd(second, -1, dateadd(day, 7, dateadd(day, - (datepart(weekday, rm.StartInterval) + 5) % 7,
                                                       cast(rm.StartInterval as date))))                 as PeriodEnd,
           count(*)                                                                                      as TotalIntervals,
           sum(case when rm.RMSVoltage between (0.90 * sp.ParameterValue) and (1.10 * sp.ParameterValue) then 1
                    else 0 end)                                                                          as Count_InRange
    from dbo.VoltageRMSMeasurement              as rm
             inner join dbo.MeasurementSession  as ms on rm.SessionID = ms.SessionID
             inner join dbo.MeasurementLocation as loc on ms.LocationID = loc.LocationID
             inner join dbo.SystemParameter     as sp on sp.ParameterName = 'NominalVoltage'
    group by loc.LocationID,
             dateadd(day, - (datepart(weekday, rm.StartInterval) + 5) % 7, cast(rm.StartInterval as date)),
             dateadd(second, -1, dateadd(day, 7, dateadd(day, - (datepart(weekday, rm.StartInterval) + 5) % 7,
                                                         cast(rm.StartInterval as date))));
go