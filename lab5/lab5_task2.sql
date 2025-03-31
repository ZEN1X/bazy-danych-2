-- Zadanie 1
use [master];
go

-- Utworzenie loginu dla grupa3
create login [WINSERV01\grupa3] from windows with default_database = [master];
go

-- Nadanie ról
exec sp_addsrvrolemember @loginame = N'WinServ01\grupa3', @rolename = N'dbcreator';
go

exec sp_addsrvrolemember @loginame = N'WinServ01\grupa3', @rolename = N'serveradmin';
go

-- Weryfikacja
select 'grupa3'                                            as UserName,
       is_srvrolemember('dbcreator', 'WINSERV01\grupa3')   as IsDbCreator,
       is_srvrolemember('serveradmin', 'WINSERV01\grupa3') as IsServerAdmin;
go

-- Testowanie zakresu funkcji

-- Testuje dbcreator
create database TestDB_byTester6;
go

drop database TestDB_byTester6;
go

-- Testuje serveradmin
exec sp_configure 'show advanced options', 1;

reconfigure;
go
