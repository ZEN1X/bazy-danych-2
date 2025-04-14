use [testCLR];
go

select dbo.fnGetCurrentTime();

select dbo.fnGreet();

exec dbo.udpFindByEmail 'sharon';
