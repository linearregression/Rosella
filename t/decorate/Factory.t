INIT {
    pir::load_bytecode("rosella/test.pbc");
    pir::load_bytecode("rosella/decorate.pbc");
}

Rosella::Test::test(Decorate::Factory::Test);

class Decorate::Factory::Test {
    method test_BUILD() {
        $!status.unimplemented("Write tests for this");
    }

    method create() {
        $!status.unimplemented("Write tests for this");
    }

    method create_typed() {
        $!status.unimplemented("Write tests for this");
    }
}