use [testCLR];
go

drop table if exists test1;
go

create table test1
(
    id   int identity (1,1) primary key,
    data nvarchar(max) not null
);
go

drop table if exists test1_log;
go

create table test1_log
(
    log_id     int identity (1,1) primary key,
    log_date   datetimeoffset default sysdatetimeoffset() not null,
    user_login nvarchar(max)                              not null,
    data       nvarchar(max)                              not null
);
go
