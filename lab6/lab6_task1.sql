-- Zadanie 1

/*
 Opracować skrypt T-SQL tworzący użytkownika Lab6user w bazie SQL Server (jeżeli
 istnieje usunąć), bazę danych Lab6db (jeżeli istnieje usunąć) oraz na koniec przypisać
 użytkownika Lab6user jako db_owner do bazy danych Lab6db.
 */

use [master];
go

-- tworzymy nowy login
if exists ( select name
            from sys.server_principals
            where name = 'Lab6user' )
    begin
        drop login [Lab6user];
    end
go

create login [Lab6user] with password = 'Passw0rd';
go

-- tworzymy nową bazę danych
if exists ( select name
            from sys.databases
            where name = 'Lab6db' )
    begin
        -- dla bezpieczeństwa rozłączmy wszystkich poza nami
        alter database Lab6db set single_user with rollback immediate;
        drop database Lab6db;
    end
go

create database Lab6db;
go

-- tworzymy nowego użytkownika w bazie "Lab6db"
use [Lab6db];
go

drop user if exists [Lab6user];
go

create user [Lab6user] for login [Lab6user];
go;

-- przypisujemy użytkownika do roli
alter role [db_owner] add member [Lab6user];
go
