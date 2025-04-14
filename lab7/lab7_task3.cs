using System;
using Microsoft.SqlServer.Server;
using System.Data.SqlClient;

public static class EmployeeSearch
{
    [SqlProcedure]
    public static void SearchByEmailSubstring(string substring)
    {
        using (SqlConnection conn = new SqlConnection("context connection=true"))
        {
            conn.Open();

            string query = @"
                SELECT em.BusinessEntityID, pp.FirstName + ' ' + pp.LastName as Name, ea.EmailAddress
                FROM AdventureWorks2019.HumanResources.Employee em
                JOIN AdventureWorks2019.Person.EmailAddress ea ON em.BusinessEntityID = ea.BusinessEntityID
                JOIN AdventureWorks2019.Person.Person pp ON ea.BusinessEntityID = pp.BusinessEntityID
                WHERE ea.EmailAddress LIKE '%' + @substring + '%'";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@substring", substring);
                SqlContext.Pipe.ExecuteAndSend(cmd);
            }
        }
    }
}
