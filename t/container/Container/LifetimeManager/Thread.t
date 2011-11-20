// Automatically generated test for Class Rosella.Container.LifetimeManager.Thread
function create_new(var p_args [slurpy], var n_args [slurpy,named])
{
    return new Rosella.Container.LifetimeManager.Thread(p_args:[flat], n_args:[flat,named]);
}

class Test_Rosella_Container_LifetimeManager_Thread
{
    function test_sanity()
    {
        self.assert.is_true(1);
    }

    function test_new()
    {
        // Test simple constructor. For most individual method tests, use create_new() above
        var obj = new Rosella.Container.LifetimeManager.Thread();
        self.assert.not_null(obj);
        self.assert.instance_of(obj, class Rosella.Container.LifetimeManager.Thread);
    }


    function Thread()
    {
        self.status.verify("Test Rosella.Container.LifetimeManager.Thread.Thread()");
        var obj = create_new();

        var result = obj.Thread();
    }

    function has_instance()
    {
        self.status.verify("Test Rosella.Container.LifetimeManager.Thread.has_instance()");
        var obj = create_new();

        var result = obj.has_instance();
    }

    function set_instance()
    {
        self.status.verify("Test Rosella.Container.LifetimeManager.Thread.set_instance()");
        var obj = create_new();

        var result = obj.set_instance();
    }

    function get_instance()
    {
        self.status.verify("Test Rosella.Container.LifetimeManager.Thread.get_instance()");
        var obj = create_new();

        var result = obj.get_instance();
    }
}

function main[main]()
{
    var core = load_packfile("rosella/core.pbc");
    var(Rosella.initialize_rosella)("test");
    var(Rosella.load_bytecode_file)("rosella/container.pbc", "load");
    var(Rosella.Test.test)(class Test_Rosella_Container_LifetimeManager_Thread);
}
