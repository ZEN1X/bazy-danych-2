-- tworzenie bazy
create database PowerQualityDB;
go

use PowerQualityDB;
go

-- tabela producentów urządzeń pomiarowych
create table dbo.DeviceVendor
(
    VendorID   int identity (1,1) not null primary key,
    VendorName nvarchar(100)      not null
);
go

-- tabela urządzeń pomiarowych
create table dbo.MeasurementDevice
(
    DeviceID         bigint identity (1,1) not null primary key,
    VendorID         int                   not null,
    Model            nvarchar(50)          not null,
    SerialNumber     nvarchar(50)          null,
    CalibrationDate  date                  null,
    InstallationDate date                  null,
    Description      nvarchar(200)         null,
    constraint FK_Device_DeviceVendor foreign key (VendorID) references dbo.DeviceVendor (VendorID)
);
go

-- lokalizacje pomiarów
create table dbo.MeasurementLocation
(
    LocationID  bigint identity (1,1) not null primary key,
    Name        nvarchar(100)         not null,
    Description nvarchar(200)         null
);
go

-- sesje pomiarowe (czyli np. jeden plik zawierający pomiary)
create table dbo.MeasurementSession
(
    SessionID  bigint identity (1,1) not null primary key,
    DeviceID   bigint                not null,
    LocationID bigint                not null,
    StartTime  datetime2(3)          not null,
    EndTime    datetime2(3)          null, -- null, jeśli jeszcze trwa
    constraint FK_Session_Device foreign key (DeviceID) references dbo.MeasurementDevice (DeviceID),
    constraint FK_Session_Location foreign key (LocationID) references dbo.MeasurementLocation (LocationID)
);
go

-- pomiary częstotliwości
create table dbo.FrequencyMeasurement
(
    SessionID       bigint        not null,
    MeasurementTime datetime2(3)  not null,
    FrequencyHz     decimal(8, 5) not null,
    AggregationSec  int           not null default (10),
    constraint PK_FrequencyMeasurement primary key (SessionID, MeasurementTime),
    constraint FK_Freq_Session foreign key (SessionID) references dbo.MeasurementSession (SessionID)
);

create index IDX_Freq_Session_Time on dbo.FrequencyMeasurement (SessionID, MeasurementTime) include (FrequencyHz, AggregationSec);
go

-- pomiary napięcia
create table dbo.VoltageMeasurement
(
    SessionID       bigint        not null,
    MeasurementTime datetime2(3)  not null,
    Phase           tinyint       not null, -- 1=L1, 2=L2, 3=L3, 4=N, 5=PE, SQL Server nie ma enum'ów :(
    AvgVoltage      decimal(9, 3) not null,
    MinVoltage      decimal(9, 3) not null,
    MaxVoltage      decimal(9, 3) not null,
    AggregationSec  int           not null default (10),
    constraint PK_VoltageMeasurement primary key (SessionID, MeasurementTime, Phase),
    constraint FK_Volt_Session foreign key (SessionID) references dbo.MeasurementSession (SessionID)
);

create index IDX_Volt_Session_Time on dbo.VoltageMeasurement (SessionID, MeasurementTime, Phase) include (AvgVoltage, MinVoltage, MaxVoltage, AggregationSec);
go

-- pomiary prądu
create table dbo.CurrentMeasurement
(
    SessionID       bigint         not null,
    MeasurementTime datetime2(3)   not null,
    Phase           tinyint        not null, -- 1=L1, 2=L2, 3=L3, 4=N, 5=PE, SQL Server nie ma enum'ów :(
    AvgCurrent      decimal(10, 3) not null,
    MinCurrent      decimal(10, 3) not null,
    MaxCurrent      decimal(10, 3) not null,
    InstantCurrent  decimal(10, 3) null,
    AggregationSec  int            not null default (10),
    constraint PK_CurrentMeasurement primary key (SessionID, MeasurementTime, Phase),
    constraint FK_Curr_Session foreign key (SessionID) references dbo.MeasurementSession (SessionID)
);

create index IDX_Curr_Session_Time on dbo.CurrentMeasurement (SessionID, MeasurementTime, Phase) include (AvgCurrent, MinCurrent, MaxCurrent, InstantCurrent, AggregationSec);
go

-- moce: P, Q, D, S + charakter mocy biernej
create table dbo.PowerMeasurement
(
    SessionID         bigint         not null,
    MeasurementTime   datetime2(3)   not null,
    ActivePower_P     decimal(12, 3) not null,
    ReactivePower_Q   decimal(12, 3) not null,
    DistortionPower_D decimal(12, 3) not null,
    ApparentPower_S   decimal(12, 3) not null,
    ReactiveType      tinyint        not null, -- 1 = indukcyjna, 2 = pojemnościowa
    constraint PK_PowerMeasurement primary key (SessionID, MeasurementTime),
    constraint FK_Power_Session foreign key (SessionID) references dbo.MeasurementSession (SessionID)
);

create index IDX_Power_Session_Time on dbo.PowerMeasurement (SessionID, MeasurementTime) include (ActivePower_P,
                                                                                                  ReactivePower_Q,
                                                                                                  DistortionPower_D,
                                                                                                  ApparentPower_S,
                                                                                                  ReactiveType);
go

-- energie: EP, EQ, ES
create table dbo.EnergyMeasurement
(
    SessionID         bigint         not null,
    MeasurementTime   datetime2(3)   not null,
    ActiveEnergy_EP   decimal(14, 3) not null,
    ReactiveEnergy_EQ decimal(14, 3) not null,
    ApparentEnergy_ES decimal(14, 3) not null,
    constraint PK_EnergyMeasurement primary key (SessionID, MeasurementTime),
    constraint FK_Energy_Session foreign key (SessionID) references dbo.MeasurementSession (SessionID)
);

create index IDX_Energy_Session_Time on dbo.EnergyMeasurement (SessionID, MeasurementTime) include (ActiveEnergy_EP, ReactiveEnergy_EQ, ApparentEnergy_ES);
go

-- power factor
create table dbo.PowerFactorMeasurement
(
    SessionID       bigint        not null,
    MeasurementTime datetime2(3)  not null,
    PowerFactor_PF  decimal(6, 4) not null,
    CosPhi          decimal(6, 4) not null,
    TanPhi          decimal(6, 4) not null,
    constraint PK_PowerFactorMeasurement primary key (SessionID, MeasurementTime),
    constraint FK_PF_Session foreign key (SessionID) references dbo.MeasurementSession (SessionID)
);

create index IDX_PF_Session_Time on dbo.PowerFactorMeasurement (SessionID, MeasurementTime) include (PowerFactor_PF, CosPhi, TanPhi);
go

-- wskaźniki migotania: PST, PLT
create table dbo.FlickerMeasurement
(
    SessionID       bigint        not null,
    MeasurementTime datetime2(3)  not null,
    PST             decimal(7, 4) not null,
    PLT             decimal(7, 4) not null,
    constraint PK_FlickerMeasurement primary key (SessionID, MeasurementTime),
    constraint FK_Flicker_Session foreign key (SessionID) references dbo.MeasurementSession (SessionID)
);

create index IDX_Flicker_Session_Time on dbo.FlickerMeasurement (SessionID, MeasurementTime) include (PST, PLT);
go

-- harmoniczne: THD etc.
create table dbo.HarmonicMeasurement
(
    SessionID       bigint        not null,
    MeasurementTime datetime2(3)  not null,
    Phase           tinyint       not null, -- 1=L1, 2=L2, 3=L3
    HarmonicOrder   tinyint       not null, -- 2 .. 13
    THD             decimal(6, 3) not null, -- [%]
    constraint PK_HarmonicMeasurement primary key (SessionID, MeasurementTime, Phase, HarmonicOrder),
    constraint FK_Harmonic_Session foreign key (SessionID) references dbo.MeasurementSession (SessionID)
);

create index IDX_Harmonic_Session_Time on dbo.HarmonicMeasurement (SessionID, MeasurementTime, Phase, HarmonicOrder) include (THD);
go

-- wskaźniki jakości, dla każdej lokalizacji, dla tygodnia
create table dbo.QualityIndicator
(
    IndicatorID bigint identity (1,1) not null primary key,
    LocationID  bigint                not null,
    PeriodStart date                  not null,
    PeriodEnd   date                  not null,
    W1          decimal(7, 4)         not null,
    W2          decimal(7, 4)         not null,
    W3          decimal(7, 4)         not null,
    W4          decimal(7, 4)         not null,
    CWJU        decimal(7, 4)         not null,
    constraint UQ_QualityIndicator_Loc_Period unique (LocationID, PeriodStart),
    constraint FK_Indicator_Location foreign key (LocationID) references dbo.MeasurementLocation (LocationID)
);

create index IDX_QualityIndicator_Loc_Period on dbo.QualityIndicator (LocationID, PeriodStart, PeriodEnd);
go
