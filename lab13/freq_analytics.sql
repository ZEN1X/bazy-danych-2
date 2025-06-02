create view dbo.View_FrequencyCompliance as
    select loc.LocationID,
           dateadd(day, - (datepart(weekday, fm.MeasurementTime) + 5) % 7,
                   cast(fm.MeasurementTime as date))                                       as PeriodStart,
           dateadd(second, -1, dateadd(day, 7, dateadd(day, - (datepart(weekday, fm.MeasurementTime) + 5) % 7,
                                                       cast(fm.MeasurementTime as date)))) as PeriodEnd,
           count(*)                                                                        as TotalSamples,
           sum(case when fm.FrequencyHz between 49.5 and 50.5 then 1 else 0 end)           as Count_49_5_50_5,
           sum(case when fm.FrequencyHz between 47.0 and 52.0 then 1 else 0 end)           as Count_47_52
    from dbo.FrequencyMeasurement               as fm
             inner join dbo.MeasurementSession  as ms on fm.SessionID = ms.SessionID
             inner join dbo.MeasurementLocation as loc on ms.LocationID = loc.LocationID
    group by loc.LocationID,
             dateadd(day, - (datepart(weekday, fm.MeasurementTime) + 5) % 7, cast(fm.MeasurementTime as date)),
             dateadd(second, -1, dateadd(day, 7, dateadd(day, - (datepart(weekday, fm.MeasurementTime) + 5) % 7,
                                                         cast(fm.MeasurementTime as date))));
go
