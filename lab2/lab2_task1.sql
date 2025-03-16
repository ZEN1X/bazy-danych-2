use AdventureWorks2019;

-- Zadanie 1

-- a)
/*
 Jeśli RowNumber to nazwa kolumny, na której wywołaliśmy ROW_NUMBER(),
 to wyrażenie "WHERE (RowNumber > 51) AND (RowNumber < 100)"
 wybiera nam wiersze od 52 (włącznie) do 99 (włącznie).
 */

/*
 Przykład dla zrozumienia.
 Tworzymy CTE (o nazwie Example), które zawiera:
 - nr wiersza
 - ID
 - Imię
 - Nazwisko
 posortowane po nazwisku.

 Korzystając z CTE, wybieramy wiersze, które mają nr wiersza > 51 i < 100.
 Jako że posortowaliśmy według nazwisk, alfabetycznie, to kompletnie wyrażenie
 zwróci nam pewien fragment danych.
 */
with Example as (select row_number() over (order by LastName) as RowNumber,
                        BusinessEntityID,
                        FirstName,
                        LastName
                 from Person.Person)
select *
from Example
where RowNumber > 51
  and RowNumber < 100;

-- b) stronicowanie
-- I. tabela temporary
select ROW_NUMBER() over (order by LastName) as RowNumber,
       BusinessEntityID,
       FirstName,
       LastName
into #TemporaryPerson -- # oznacza tabelę tymczasową, lokalną
from Person.Person;

select *
from #TemporaryPerson
where RowNumber > 51
  and RowNumber < 100;

-- II.
with CTEPerson as (select ROW_NUMBER() over (order by LastName) as RowNumber,
                          BusinessEntityID,
                          FirstName,
                          LastName
                   from Person.Person)
select *
from CTEPerson
where RowNumber > 51
  and RowNumber < 100;
