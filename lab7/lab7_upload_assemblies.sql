use [testCLR];
go

create assembly [Lab7.GetCurrentTime] from 'C:\Users\Administrator\Desktop\lab7\tasks\lab7_task1.dll';
go

create assembly [Lab7.ShowGreeting] from 'C:\Users\Administrator\Desktop\lab7\tasks\lab7_task2.dll';
go

create assembly [Lab7.FindByEmail] from 'C:\Users\Administrator\Desktop\lab7\tasks\lab7_task3.dll';
go

create function [dbo].[fnGetCurrentTime]() returns nvarchar(200) as
    external name [Lab7.GetCurrentTime] . [TimeFunc] . [GetSystemTime];
go

create function [dbo].[fnGreet]() returns nvarchar(max) as
    external name [Lab7.ShowGreeting] . [GreetingFunc] . [Greet];
go

create procedure [dbo].[udpFindByEmail] @substring nvarchar(200) as
    external name [Lab7.FindByEmail] . [EmployeeSearch] . [SearchByEmailSubstring];
go
