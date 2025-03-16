use AdventureWorks2019;
go;

-- row_number()
SELECT row_number() OVER (ORDER BY [LastName]) AS RowNumber,
       [BusinessEntityID],
       [FirstName],
       [LastName]
FROM [Person].[Person]

-- rank, dense_rank, ntile
SELECT Row_Number() OVER (ORDER BY [LastName]) AS RowNumber
     , Rank() OVER (ORDER BY [LastName])       AS Rank
     , Dense_Rank() OVER (ORDER BY [LastName]) AS DenseRank
     , NTile(3) OVER (ORDER BY [LastName])     AS NTile_3
     , NTile(4) OVER (ORDER BY [LastName])     AS NTile_4
     , [BusinessEntityID]
     , [FirstName]
     , [LastName]
FROM [Person].[Person];

