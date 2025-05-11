use [testCLR];
go

-- Zadanie 1
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

-- Zadanie 2
drop table if exists a;
go

create table a
(
    a_id int identity (1,1) primary key,
    data nvarchar(100) not null
);
go

drop table if exists b;
go

create table b
(
    b_id int identity (1,1) primary key,
    data nvarchar(100) not null
);
go

drop table if exists a_b;
go

create table a_b
(
    ab_a_id int not null foreign key references a (a_id),
    ab_b_id int not null foreign key references b (b_id),
    primary key (ab_a_id, ab_b_id)
);
go
