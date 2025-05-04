using System;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedAggregate(Format.Native)]
public struct CountDivBy3
{
    private SqlInt32 _count;

    public void Init() => _count = 0;

    public void Accumulate(SqlInt32 Value)
    {
        if (!Value.IsNull && Value.Value >= 0 && Value.Value % 3 == 0)
        {
            _count += 1;
        }
    }

    public void Merge(CountDivBy3 Group) => _count += Group._count;

    public SqlInt32 Terminate() => _count;
}
