use AdventureWorks2019;

-- Zadanie 2
/*
 Utwórz raport podający ilość dostawców o adresie głównej siedziby
 podzielony wg stanu i miasta. Dane pochodzą z tabel Purchasing.Vendor,
 Purchasing.VendorAddress, Person.Address, Person.StateProvince.
 */

select sp.Name                   as State,
       a.City,
       count(v.BusinessEntityID) as NoOfVendors -- zliczamy ilość dostawców
from Purchasing.Vendor v
         join Person.BusinessEntityAddress bea on v.BusinessEntityID = bea.BusinessEntityID
         join Person.Address a on bea.AddressID = a.AddressID
         join Person.StateProvince sp on a.StateProvinceID = sp.StateProvinceID
where bea.AddressTypeID = 3 -- główna siedziba — Main Office
group by sp.Name, a.City -- dzielimy według stanu i miasta
order by sp.Name, a.City;
