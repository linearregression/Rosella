// Automatically generated test for Class Rosella.Date.SpecialDate.Minimum
function create_new(var p_args [slurpy], var n_args [slurpy,named])
{
    return new Rosella.Date.SpecialDate.Minimum(p_args:[flat], n_args:[flat,named]);
}

class Test_Rosella_Date_SpecialDate_Minimum
{
    function cmp()
    {
        self.status.verify("Test Rosella.Date.SpecialDate.Minimum.cmp()");
        var obj = create_new();

        var arg_0 = null;
        var result = obj.cmp(arg_0);
    }
}

function main[main]()
{
    var core = load_packfile("rosella/core.pbc");
    var(Rosella.initialize_rosella)("test");
    var(Rosella.load_bytecode_file)("rosella/date.pbc", "load");
    var(Rosella.Test.test)(class Test_Rosella_Date_SpecialDate_Minimum);
}
