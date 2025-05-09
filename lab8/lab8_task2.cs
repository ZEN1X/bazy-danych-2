using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class DateUDF
{
    [SqlFunction(Name = "udf_FormatDate", IsDeterministic = true, IsPrecise = true)]
    public static SqlString FormatDate(SqlDateTime dateValue, SqlString formatString)
    {
        if (dateValue.IsNull || formatString.IsNull)
            return SqlString.Null;
        return new SqlString(dateValue.Value.ToString(formatString.Value));
    }
}
