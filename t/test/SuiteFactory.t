INIT {
    pir::load_bytecode("rosella/test.pbc");
}

class MyFakeTestClass {}

Rosella::Test::test(Test::SuiteFactory::Test);
class Test::SuiteFactory::Test {
    method basic_BUILD() {
        my $factory := Rosella::build(Rosella::Test::SuiteFactory,
            Rosella::Test::Suite, MyFakeTestClass, Rosella::Test::TestCase,
            "Context"
        );
    }

    method test_create_Suite() {
        my $factory := Rosella::build(Rosella::Test::SuiteFactory,
            Rosella::Test::Suite, MyFakeTestClass, Rosella::Test::TestCase,
            "Context"
        );
        my $suite := $factory.create();
        Assert::instance_of($suite, Rosella::Test::Suite);
    }

    method test_create_custom_suite() {
        $!status.unimplemented("test .create() with a custom type");
    }

    method test_create_typed_custom_suite() {
        $!status.unimplemented("test .create_typed() with a custom type");
    }

    method test_create_typed_Suite() {
        my $factory := Rosella::build(Rosella::Test::SuiteFactory,
            Rosella::Test::Suite, MyFakeTestClass, Rosella::Test::TestCase,
            "Context"
        );
        my $suite := $factory.create_typed(Rosella::Test::Suite);
        Assert::instance_of($suite, Rosella::Test::Suite);
    }

    method test_testcase_subclass() {
        $!status.unimplemented("Test using SuiteFactory with a subclass of TestCase");
    }

    method test_context() {
        $!status.unimplemented("Test using a custom TestContext object. Show that it is passed to all tests in the Suite");
    }
}