using System;
using Microsoft.SqlServer.Server;
using System.Data.SqlClient;

public partial class GreetingFunc
{
    [SqlFunction]
    public static string Greet()
    {
        string login = "", serverName = "", version = "", userName = "";

        using (SqlConnection conn = new SqlConnection("context connection=true"))
        {
            conn.Open();

            // chained using()
            using(SqlCommand command = new SqlCommand("select suser_name(), @@servername, @@version, system_user", conn))
            using(SqlDataReader reader = command.ExecuteReader())
            {
                if (reader.Read())
                {
                    login = reader[0].ToString();
                    serverName = reader[1].ToString();
                    version = reader[2].ToString();
                    userName = reader[3].ToString();
                }
            }
        }

        return $"Witaj: {login}, dzisiaj jest: {DateTime.Now:yyyy-MM-dd}, pracujesz na serwerze {serverName} w systemie {version} jako {userName}.";
    }
}
