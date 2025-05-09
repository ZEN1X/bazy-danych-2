using System.Collections;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class TableValued
{
    private class Row
    {
        public SqlInt32 id;
        public SqlString fn, ln, addr;
        public Row(SqlInt32 id, SqlString fn, SqlString ln, SqlString addr)
        {
            this.id = id; this.fn = fn; this.ln = ln; this.addr = addr;
        }
    }

    [SqlFunction(
      Name = "udf_GetEmployeesByAddress",
      DataAccess = DataAccessKind.Read,
      FillRowMethodName = "FillRow",
      TableDefinition = @"
        BusinessEntityID int,
        FirstName        nvarchar(50),
        LastName         nvarchar(50),
        AddressLine1     nvarchar(100)"
    )]

    public static IEnumerable GetEmployeesByAddress(SqlString searchPattern)
    {
        string pattern = searchPattern.IsNull ? null : searchPattern.Value;
        var list = new ArrayList();

        using (var conn = new SqlConnection("context connection=true"))
        using (SqlCommand cmd = new SqlCommand(@"
         select e.BusinessEntityID, p.FirstName, p.LastName, a.AddressLine1
         from AdventureWorks2019.HumanResources.Employee      as e
         join AdventureWorks2019.Person.Person                as p on e.BusinessEntityID = p.BusinessEntityID
         join AdventureWorks2019.Person.BusinessEntityAddress as bea on e.BusinessEntityID = bea.BusinessEntityID
         join AdventureWorks2019.Person.Address               as a on bea.AddressID = a.AddressID;", conn))
        {
            conn.Open();

            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    string addr = reader.GetString(3);

                    if (pattern != null && addr.Contains(pattern))
                    {
                        list.Add(new Row(
                            reader.GetSqlInt32(0),
                            reader.GetSqlString(1),
                            reader.GetSqlString(2),
                            reader.GetSqlString(3)
                        ));
                    }
                }
            }
        }

        return list;
    }

    public static void FillRow(
        object obj,
        out SqlInt32 BusinessEntityID,
        out SqlString FirstName,
        out SqlString LastName,
        out SqlString AddressLine1
    )
    {
        var rec = (Row)obj;
        BusinessEntityID = rec.id;
        FirstName = rec.fn;
        LastName = rec.ln;
        AddressLine1 = rec.addr;
    }
}
