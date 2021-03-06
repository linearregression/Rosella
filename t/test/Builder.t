INIT {
    my $rosella := pir::load_bytecode__PS("rosella/core.pbc");
    Rosella::initialize_rosella("test");
}

Rosella::Test::test(Test::Builder::Test);

class Test::Builder::Test {
    method test_BUILD() {
        my $builder := Rosella::construct(Rosella::Test::Builder, 0);
        $!assert.instance_of($builder, Rosella::Test::Builder);
    }

    method test_todo() {
        $!assert.output_is({
            my $builder := Rosella::construct(Rosella::Test::Builder, 0);
            $builder.todo(1, "this is a message");
        }, "ok 1 - this is a message # TODO \n");
        $!assert.output_is({
            my $builder := Rosella::construct(Rosella::Test::Builder, 0);
            $builder.todo(0, "oops failed");
        }, "not ok 1 - oops failed # TODO \n");
        $!assert.output_is({
            my $builder := Rosella::construct(Rosella::Test::Builder, 0);
            $builder.todo(1, "passed", "explanation");
        }, "ok 1 - passed # TODO explanation\n");
        $!assert.output_is({
            my $builder := Rosella::construct(Rosella::Test::Builder, 0);
            $builder.todo(0, "failed", "explanation");
        }, "not ok 1 - failed # TODO explanation\n");
    }

    method test_ok() {
        $!assert.output_is({
            my $builder := Rosella::construct(Rosella::Test::Builder, 0);
            $builder.ok(1);
        }, "ok 1\n");
        $!assert.output_is({
            my $builder := Rosella::construct(Rosella::Test::Builder, 0);
            $builder.ok(1, "message");
        }, "ok 1 - message\n");
        $!assert.output_is({
            my $builder := Rosella::construct(Rosella::Test::Builder, 0);
            $builder.ok(0);
        }, "not ok 1\n");
        $!assert.output_is({
            my $builder := Rosella::construct(Rosella::Test::Builder, 0);
            $builder.ok(0, "message");
        }, "not ok 1 - message\n");
    }

    method test_diag() {
        $!assert.output_is({
            my $builder := Rosella::construct(Rosella::Test::Builder, 0);
            $builder.diag("string message");
        }, "# string message\n");
        # TODO: Test diag with an Exception argument
    }

    method test_plan() {
        $!assert.output_is({
            my $builder := Rosella::construct(Rosella::Test::Builder, 0);
            $builder.plan(5);
        }, "1..5\n");
    }
}
