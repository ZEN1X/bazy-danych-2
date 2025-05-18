-- Zadanie 1
declare @xdoc xml;

-- a)
set @xdoc = '<?xml version="1.0" encoding="UTF-8" ?>
<lista/>';

-- b)
set @xdoc.modify('insert <student><nazwisko>Kowalski</nazwisko><imie>Adam</imie></student> as last into /lista[1]');

set @xdoc.modify('insert <student><nazwisko>Tokarski</nazwisko><imie>Maciej</imie></student> as last into /lista[1]');

set @xdoc.modify('insert <student><nazwisko>Dobry</nazwisko><imie>Aleksandra</imie></student> as last into /lista[1]');

set @xdoc.modify('insert <student><nazwisko>Bednarz</nazwisko><imie>Julia</imie></student> as last into /lista[1]');

set @xdoc.modify('insert <student><nazwisko>Tekielski</nazwisko><imie>Tomasz</imie></student> as last into /lista[1]');

-- c)
declare @cnt int = @xdoc.value('count(/lista/student)', 'int');

declare @i int = 1;

while @i <= @cnt begin
    set @xdoc.modify('
    insert <grupa>{sql:variable("@i")}</grupa> as last into ((//student)[sql:variable("@i")])[1]');
    set @i += 1;
end

-- d)
select tab.col.value('(nazwisko)[1]', 'nvarchar(50)') as nazwisko,
       tab.col.value('(imie)[1]', 'nvarchar(50)')     as imie,
       tab.col.value('(grupa)[1]', 'int')             as grupa
from @xdoc.nodes('//student') as tab(col);

go
