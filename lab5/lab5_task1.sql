-- Zadanie 1
use [master];
go

-- Pierw oczywiście tworzymy odpowiednich użytkowników i grupy w systemie Windows.

-- Utworzenie loginów dla grup: grupa1, grupa2
create login [WINSERV01\grupa1] from windows with default_database = [AdventureWorks2019];
go

-- grupa1 może się logować
grant connect sql to [WINSERV01\grupa1];
go

create login [WINSERV01\grupa2] from windows with default_database = [AdventureWorks2019];
go

-- grupa 2 nie może się logować
deny connect sql to [WINSERV01\grupa2];
go

-- wyświetlenie efektów poleceń
select name, princ.type_desc, princ.default_database_name, perm.permission_name, perm.state_desc
from sys.server_principals                as princ
         left join sys.server_permissions as perm
                   on princ.principal_id = perm.grantee_principal_id and perm.class_desc = 'SERVER'
where princ.name in ('WINSERV01\grupa1', 'WINSERV01\grupa2');

-- Jakie jest efektywne uprawnienie dla użytkownika należącego do obu grup?
/*
 W naszym przypadku dotyczy to użytkownika tester3, który należy jednocześnie do grupa1 i grupa2.
 grupa1 ma grant, a grupa2 ma deny.
 Zgodnie z hierarchią, deny ma wyższy priorytet, niż grant.
 Wobec czego tester3 nie może się zalogować.
 */

-- Jakie są uprawnienia (jaka rola) do domyślnej bazy danych?
/*
 W naszym przypadku domyślna baza danych to AdventureWorks2019 (tak przypisaliśmy w create login, inaczej byłoby to master).
 Jeśli nic dodatkowo nie przypiszemy, to nowy login ma podstawową rolę public (server role).
 Jeśli chodzi o uprawnienia do bazy danych (database role), to póki nie stworzymy mappingu (tzn. utworzymy user na bazie), to nie mamy nic.
 Chodzi mi tutaj o to, że mamy sam login (czyli na poziomie server), a nie user (na poziomie bazy).
 Oczywiście, gdy mamy / stworzymy user i zrobimy mapping, to będzie on miał rolę public (database role).
 */