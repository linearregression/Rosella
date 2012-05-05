// Automatically generated test for Class Rosella.Net.Http.Response
function create_new(var p_args [slurpy], var n_args [slurpy,named])
{
    return new Rosella.Net.Http.Response(p_args:[flat], n_args:[flat,named]);
}

class Test_Rosella_Net_Http_Response
{
    function test_new()
    {
        // Test simple constructor. For most individual method tests, use create_new() above
        var obj = new Rosella.Net.Http.Response(200);
        self.assert.not_null(obj);
        self.assert.instance_of(obj, class Rosella.Net.Http.Response);
    }

    function header()
    {
        self.status.verify("Test Rosella.Net.Http.Response.header()");
        var obj = create_new(200);

        var result = obj.header();
        self.assert.not_null(result);
    }

    function status_code()
    {
        self.status.verify("Test Rosella.Net.Http.Response.status_code()");
        var obj = create_new(200);

        int result = obj.status_code();
        self.assert.equal(result, 200);
    }
}

function initialize_test[anon](var context)
{
    // Set up the test suite here. Set options on the Suite, set up matchers
    // in the matcher factory, load prerequisites, and do other things.
    var(Rosella.load_bytecode_file)("rosella/net.pbc", "load");
}

function main[main]()
{
    var core = load_packfile("rosella/core.pbc");
    var(Rosella.initialize_rosella)("test");
    using initialize_test;
    var(Rosella.Test.test)(class Test_Rosella_Net_Http_Response, initialize_test:[named("initialize")]);
}
