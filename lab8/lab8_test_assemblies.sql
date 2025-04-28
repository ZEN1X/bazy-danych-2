use [testCLR];
go

-- Zadanie 1
exec usp_FindEmployeesByAddress N'Drive';
go

-- Zadanie 2
select dbo.udf_FormatDate(getdate(), 'yyyy-MM-dd HH:mm:ss');
go

-- Zadanie 3
select *
from dbo.udf_GetEmployeesByAddress(N'Drive');
go
