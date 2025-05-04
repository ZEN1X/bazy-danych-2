using System;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedAggregate(Format.Native)]
public struct UdaAvg
{
    private SqlDouble _sum;
    private SqlInt32 _n;

    public void Init()
    {
        _sum = 0;
        _n = 0;
    }

    public void Accumulate(SqlDouble Value)
    {
        if (!Value.IsNull)
        {
            _sum += Value;
            _n += 1;
        }
    }

    public void Merge(UdaAvg Group)
    {
        _sum += Group._sum;
        _n += Group._n;
    }

    public SqlDouble Terminate()
    {
        return _n > 0 ? _sum / _n : SqlDouble.Null;
    }
}

[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedAggregate(Format.Native)]
public struct UdaVar
{
    private SqlDouble _sum;
    private SqlDouble _sumSq;
    private SqlInt32 _count;

    public void Init()
    {
        _sum = 0;
        _sumSq = 0;
        _count = 0;
    }

    public void Accumulate(SqlDouble Value)
    {
        if (!Value.IsNull)
        {
            _sum += Value;
            _sumSq += Math.Pow(Value.Value, 2);
            _count += 1;
        }
    }

    public void Merge(UdaVar Group)
    {
        _sum += Group._sum;
        _sumSq += Group._sumSq;
        _count += Group._count;
    }

    public SqlDouble Terminate()
    {
        if (_count < 2)
        {
            return SqlDouble.Null;
        }

        return (_sumSq - (_sum * _sum) / _count) / (_count - 1);
    }
}

[Serializable]
[SqlUserDefinedAggregate(Format.Native)]
public struct UdaStdev
{
    private UdaVar _var;

    public void Init()
    {
        _var.Init();
    }

    public void Accumulate(SqlDouble Value)
    {
        _var.Accumulate(Value);
    }

    public void Merge(UdaStdev Group)
    {
        _var.Merge(Group._var);
    }

    public SqlDouble Terminate()
    {
        var v = _var.Terminate();

        return v.IsNull ? SqlDouble.Null : Math.Sqrt(v.Value);
    }
}