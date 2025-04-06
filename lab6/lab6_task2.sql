-- Zadanie 2

/*
 Opracować procedurę T-SQL tworzącą następujące tabele w utworzonej bazie danych
 Lab6db oraz odpowiednie relacje pomiędzy tabelami:
 student ( id int PK, fname varchar(30), lname varchar(30) )
 wykladowca ( id int PK , fname varchar(30), lname varchar(30) )
 przedmiot ( id int PK , name varchar(50) )
 grupa ( id_wykl int, id_stud int, id_przed int )
 (id_wykl FK(wykladowca id), id_stud FK(student id), id_przed FK(przedmiot id)) PK
 */

use [Lab6db];
go

drop procedure if exists usp_Lab6;
go

create procedure usp_Lab6 as
begin
    set nocount on;

    drop table if exists grupa;
    drop table if exists student;
    drop table if exists wykladowca;
    drop table if exists przedmiot;

    create table student
    (
        id    int primary key,
        fname varchar(30),
        lname varchar(30)
    );

    create table wykladowca
    (
        id    int primary key,
        fname varchar(30),
        lname varchar(30)
    );

    create table przedmiot
    (
        id   int primary key,
        name varchar(50)
    );

    create table grupa
    (
        id_wykl  int,
        id_stud  int,
        id_przed int,

        primary key (id_wykl, id_stud, id_przed),
        foreign key (id_wykl) references wykladowca (id),
        foreign key (id_stud) references student (id),
        foreign key (id_przed) references przedmiot (id)
    );
end
go
