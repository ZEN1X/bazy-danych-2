use AdventureWorks2019;
go

-- Zadanie 3
/*
 Opracować przykład procedury składowanej z wykorzystaniem struktury
 RAISERROR przesłania informacji o niemożliwości zrealizowania
 określonego zadania w bazie danych AdvantureWorks.
 */

if object_id('dbo.usp_GetProductByID') is not null
    drop procedure dbo.usp_GetProductByID;
go

create procedure dbo.usp_GetProductByID(@ProductID int) as
begin
    set nocount on;

    -- czy ID > 0?
    if @ProductID <= 0
        begin
            raiserror (N'ID produktu musi być większe od 0! Zadałeś %d.', 16, 1, @ProductID);
            return;
        end;

    -- czy produkt istnieje?
    if not exists ( select 1
                    from Production.Product
                    where ProductID = @ProductID )
        begin
            raiserror (N'Produkt o ID %d nie istnieje!', 16, 1, @ProductID);
            return;
        end;

    -- OK, dobre ID i produkt istnieje
    select ProductID, Name, ProductNumber, ListPrice
    from Production.Product
    where ProductID = @ProductID;
end;
go

-- Wykonanie procedury
exec dbo.usp_GetProductByID -2137;
go

exec dbo.usp_GetProductByID 2137;
go

exec dbo.usp_GetProductByID 771;
go