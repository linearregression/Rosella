// Automatically generated test for Class Rosella.Container.LifetimeManager.Transient
function create_new(var p_args [slurpy], var n_args [slurpy,named])
{
    return new Rosella.Container.LifetimeManager.Transient(p_args:[flat], n_args:[flat,named]);
}

class Test_Rosella_Container_LifetimeManager_Transient
{
    function has_instance()
    {
        self.status.verify("Test Rosella.Container.LifetimeManager.Transient.has_instance()");
        var obj = create_new();

        var result = obj.has_instance();
        self.assert.is_false(result);
    }

    function set_instance()
    {
        self.status.verify("Test Rosella.Container.LifetimeManager.Transient.set_instance()");
        var obj = create_new();

        var arg_0 = null;
        var result = obj.set_instance(arg_0);
    }

    function get_instance()
    {
        self.status.verify("Test Rosella.Container.LifetimeManager.Transient.get_instance()");
        var obj = create_new();

        var result = obj.get_instance();
        self.assert.is_null(result);
    }
}

function main[main]()
{
    var core = load_packfile("rosella/core.pbc");
    var(Rosella.initialize_rosella)("test");
    var(Rosella.load_bytecode_file)("rosella/container.pbc", "load");
    var(Rosella.Test.test)(class Test_Rosella_Container_LifetimeManager_Transient);
}
