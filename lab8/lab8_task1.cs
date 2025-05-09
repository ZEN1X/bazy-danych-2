using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class StoredProcedures
{
    [SqlProcedure(Name = "usp_FindEmployeesByAddress")]
    public static void FindEmployeesByAddress(SqlString address)
    {
        if (address.IsNull)
        {
            SqlContext.Pipe.Send("No address supplied / null!");
            return;
        }

        string pattern = address.Value;

        SqlMetaData[] meta = {
            new SqlMetaData("BusinessEntityID", SqlDbType.Int),
            new SqlMetaData("FirstName",        SqlDbType.NVarChar, 50),
            new SqlMetaData("LastName",         SqlDbType.NVarChar, 50),
            new SqlMetaData("AddressLine1",     SqlDbType.NVarChar,100)
        };

        SqlDataRecord record = new SqlDataRecord(meta);

        using (SqlConnection conn = new SqlConnection("context connection=true"))
        using (SqlCommand cmd = new SqlCommand(@"
         select e.BusinessEntityID, p.FirstName, p.LastName, a.AddressLine1
         from AdventureWorks2019.HumanResources.Employee      as e
         join AdventureWorks2019.Person.Person                as p on e.BusinessEntityID = p.BusinessEntityID
         join AdventureWorks2019.Person.BusinessEntityAddress as bea on e.BusinessEntityID = bea.BusinessEntityID
         join AdventureWorks2019.Person.Address               as a on bea.AddressID = a.AddressID;", conn))
        {
            conn.Open();

            SqlContext.Pipe.SendResultsStart(record);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    var addr = reader.GetSqlString(3);

                    if (!addr.IsNull && addr.Value.Contains(pattern))
                    {
                        record.SetInt32(0, reader.GetInt32(0));
                        record.SetString(1, reader.GetString(1));
                        record.SetString(2, reader.GetString(2));
                        record.SetString(3, reader.GetString(3));

                        SqlContext.Pipe.SendResultsRow(record);
                    }
                }
            }

            SqlContext.Pipe.SendResultsEnd();
        }
    }
}
