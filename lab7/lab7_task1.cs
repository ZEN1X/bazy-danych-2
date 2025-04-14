using System;
using Microsoft.SqlServer.Server;

public partial class TimeFunc
{
    [SqlFunction]
    public static string GetSystemTime()
    {
        return DateTime.Now.TimeOfDay.ToString();
    }
}
