-- Zadanie 3

use [AdventureWorks2019];
go

-- Nadajemy db_datawriter obu grupom
exec sp_addrolemember 'db_datawriter', 'WINSERV01\grupa1';

exec sp_addrolemember 'db_datawriter', 'WINSERV01\grupa2';
go

-- Nadanie sysadmin dla tester3
create login [WINSERV01\tester3] from windows with default_database = [AdventureWorks2019];
go

exec sp_addsrvrolemember @loginame = N'WINSERV01\tester3', @rolename = N'sysadmin';
go

-- tylko SELECT dla tester2 i tester4
-- Pierw tworzymy loginy (wcześniej były tylko dla grup)
create login [WINSERV01\tester2] from windows with default_database = [AdventureWorks2019];
go

create login [WINSERV01\tester4] from windows with default_database = [AdventureWorks2019];
go

-- Teraz tworzymy userów
create user [WINSERV01\tester2] for login [WINSERV01\tester2];
go

create user [WINSERV01\tester4] for login [WINSERV01\tester4];
go

-- Dajemy SELECT
exec sp_addrolemember 'db_datareader', 'WINSERV01\tester2';

exec sp_addrolemember 'db_datareader', 'WINSERV01\tester4';

-- Blokujemy zapis
exec sp_addrolemember 'db_denydatawriter', 'WINSERV01\tester2';

exec sp_addrolemember 'db_denydatawriter', 'WINSERV01\tester4';
go

-- teraz tester2 i tester4 nie mogą modyfikować, bo deny wyżej w hierarchii, niż grant

-- Realizacja Lab04.26
deny select on object::Person.PersonPhone to [WINSERV01\tester2];
go

grant execute on dbo.usp_GetSortedPersons to [WINSERV01\tester2];
go
