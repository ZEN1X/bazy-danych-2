using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace Lab6
{
    class Program
    {
        static string connectionString = @"Data Source=WINSERV01;Initial Catalog=Lab6db;User ID=Lab6user;Password=Passw0rd;";

        static void Main(string[] args)
        {
            try
            {
                CreateTables();
                ImportCSV();
                GetStudentCountPerLecturer();
                GetStudentCountForSubject(1);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception: " + ex.Message);
            }

            Console.WriteLine("Wcisnij klawisz...");
            Console.ReadKey();
        }

        static void CreateTables()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                using (SqlCommand cmd = new SqlCommand("usp_Lab6", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.ExecuteNonQuery();
                    Console.WriteLine("Utworzono tabele!");
                }
            }
        }

        static void ImportCSV()
        {
            ImportData("student.csv", "INSERT INTO student (id, fname, lname) VALUES (@id, @fname, @lname)", (cmd, parts) =>
            {
                cmd.Parameters.AddWithValue("@id", int.Parse(parts[0]));
                cmd.Parameters.AddWithValue("@fname", parts[1]);
                cmd.Parameters.AddWithValue("@lname", parts[2]);
            });

            ImportData("wykladowca.csv", "INSERT INTO wykladowca (id, fname, lname) VALUES (@id, @fname, @lname)", (cmd, parts) =>
            {
                cmd.Parameters.AddWithValue("@id", int.Parse(parts[0]));
                cmd.Parameters.AddWithValue("@fname", parts[1]);
                cmd.Parameters.AddWithValue("@lname", parts[2]);
            });

            ImportData("przedmiot.csv", "INSERT INTO przedmiot (id, name) VALUES (@id, @name)", (cmd, parts) =>
            {
                cmd.Parameters.AddWithValue("@id", int.Parse(parts[0]));
                cmd.Parameters.AddWithValue("@name", parts[1]);
            });

            ImportData("grupa.csv", "INSERT INTO grupa (id_wykl, id_stud, id_przed) VALUES (@id_wykl, @id_stud, @id_przed)", (cmd, parts) =>
            {
                cmd.Parameters.AddWithValue("@id_wykl", int.Parse(parts[0]));
                cmd.Parameters.AddWithValue("@id_stud", int.Parse(parts[1]));
                cmd.Parameters.AddWithValue("@id_przed", int.Parse(parts[2]));
            });
        }

        static void ImportData(string filename, string query, Action<SqlCommand, string[]> addParam)
        {
            if (!File.Exists(filename))
            {
                Console.WriteLine("Nie odnaleziono pliku: " + filename + "!");
                return;
            }

            string[] lines = File.ReadAllLines(filename);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                foreach (string line in lines)
                {
                    if (string.IsNullOrWhiteSpace(line))
                    {
                        continue;
                    }

                    string[] parts = line.Split(',');

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        addParam(cmd, parts);
                        cmd.ExecuteNonQuery();
                    }
                }

                Console.WriteLine("Wczytano dane z: " + filename + "!");
            }
        }

        static void GetStudentCountPerLecturer()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = @"
                    select w.id, w.fname, w.lname, count(g.id_stud) as StudentCount
                    from wykladowca w
                    left join grupa g on w.id = g.id_wykl
                    group by w.id, w.fname, w.lname";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        Console.WriteLine("Liczba studentow per wykladowca:");
                        while (reader.Read())
                        {
                            Console.WriteLine("ID wykladowcy: {0}, imie i nazwisko: {1} {2}, liczba studentow: {3}", reader["id"], reader["fname"], reader["lname"], reader["StudentCount"]);
                        }
                    }
                }
            }
        }

        static void GetStudentCountForSubject(int subjectId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = @"
                    select p.id, p.name, count(g.id_stud) as StudentCount
                    from przedmiot p
                    left join grupa g on p.id = g.id_przed
                    where p.id = @subjectId
                    group by p.id, p.name";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@subjectId", subjectId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        Console.WriteLine("Liczba studentow dla przedmiotu o ID " + subjectId + ":");
                        if (reader.Read())
                        {
                            Console.WriteLine("ID przedmiotu: {0}, nazwa: {1}, liczba studentow: {2}", reader["id"], reader["name"], reader["StudentCount"]);
                        }
                        else
                        {
                            Console.WriteLine("Dla przedmiotu o ID: " + subjectId + " nie ma przypisanych studentow!");
                        }
                    }
                }
            }
        }
    }
}
