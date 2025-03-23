-- Basic protection against DROP
use tempdb;
go

create table ddltest
(
    a int not null
);
go

create trigger safety on database for DROP_TABLE as print 'Musisz wylaczyc trigger przed usunieciem tabeli';

rollback;
go

-- Attempting to drop will now fail:
drop table ddltest;
