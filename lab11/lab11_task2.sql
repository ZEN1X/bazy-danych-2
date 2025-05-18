-- Zadanie 2
use master;
go

drop database if exists lab11;
go

create database lab11;
go

use lab11;
go

create xml schema collection address_schema as N'
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="adres">
        <xs:complexType>
            <xs:sequence>
                <xs:element name="miejscowosc" type="xs:string"/>
                <xs:element name="kod" type="xs:string"/>
                <xs:element name="ulica" type="xs:string"/>
                <xs:element name="numer_domu" type="xs:nonNegativeInteger"/>
                <xs:element name="numer_mieszkania" type="xs:nonNegativeInteger" minOccurs="0"/>
            </xs:sequence>
        </xs:complexType>
    </xs:element>
</xs:schema>';
go

create table students
(
    id       int primary key,
    nazwisko varchar(30)         not null,
    imie     varchar(20)         not null,
    adres    xml(address_schema) not null
);
go

insert into students
    (id, nazwisko, imie, adres)
values
    (1, 'Kowalski', 'Adam', N'
    <adres>
        <miejscowosc>Kraków</miejscowosc>
        <kod>30-059</kod>
        <ulica>Władysława Reymonta</ulica>
        <numer_domu>19</numer_domu>
    </adres>');
go

select id, nazwisko, imie, adres
from students;
go
