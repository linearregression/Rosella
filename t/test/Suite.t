INIT {
    pir::load_bytecode("rosella/test.pbc");
    pir::load_bytecode("rosella/mockobject.pbc");
}

Rosella::Test::test(Test::Suite::Test);

class MyFakeTest is Rosella::Test::Testcase {
    method test_one() {}
    method test_two() {}
    method test_three() {}
}

class MyFakeSubTest is MyFakeTest {
    method test_one() {}
    method test_four() {}
}

class Test::Suite::Test is Rosella::Test::Testcase {
    method test_BUILD() {
        my $suite := Rosella::build(Rosella::Test::Suite, [], "suite");
        Assert::not_null($suite);
    }

    method test_default_result() {
        my $suite := Rosella::build(Rosella::Test::Suite, [], "suite");
        my $result := $suite.default_result();
        Assert::equal(~(pir::typeof__SP($result)), "Rosella;Test;Result");
    }

    method test_run() {
    }

    method test_run_test() {
        my $factory := Rosella::build(Rosella::MockObject::Factory);

        # verify that we call all the right methods on the test.
        # TODO: These expectations are ordered
        my $ctest := $factory.create_typed(MyFakeTest);
        $ctest.expect_get("name").once.will_return("test_one");
        $ctest.expect_method("__set_up").once.with_no_args;
        $ctest.expect_method("test_one").once.with_no_args;
        $ctest.expect_method("__tear_down").once.with_no_args;

        # Verify that the result gets the correct details.
        my $cresult := $factory.create_typed(Rosella::Test::Loader);
        $cresult.expect_method("start_test").once.with_any_args;
        $cresult.expect_method("end_test").once.with_any_args;

        my $test := $ctest.mock();
        my $result := $cresult.mock();
        my $suite := Rosella::build(Rosella::Test::Suite, [$test], "suite");
        $suite.run_test($test, $result);
        $ctest.verify();
    }

    method test_run_test_method() {
        my $factory := Rosella::build(Rosella::MockObject::Factory);
        my $controller := $factory.create_typed(MyFakeTest);
        $controller.expect_get("name").once.will_return("test_one");
        $controller.expect_method("test_one").once.with_no_args();
        my $m := $controller.mock();
        my $suite := Rosella::build(Rosella::Test::Suite, [$m], "suite");
        $suite.run_test_method($m);
        $controller.verify();
    }
}