# Charcoal v0.1.1

An application testing suite for the Chapel language.  In contrast to `start_test`,
this suite is designed to handle integrations and application needs.  Name
delightfully suggested by @saru95

It's pretty damn primitive at the moment.  Look into the issues if you would like
to help.

Here is a page on [Error in Chapel](https://chapel-lang.org/docs/master/builtins/internal/ChapelError.html)

## Usage

When the Chapel Reflections tickets start getting closed, this package will be
greatly simplified.  Please see the [examples](examples/) to help get you started

In short, the idea is to create a testing class that extends the `UnitTest` class.

```chapel
use thingiesToTest,
    Charcoal;

class SmogReportTest: UnitTest {

  /* You can add global variables here */
  proc setUp() {}
  proc tearDown() {}

  /* initializes this test class. Should be all you need */
  proc init(verbose:bool) {
    super.init(verbose=verbose);
    this.complete();
  }


  /* Create a proc to run the specific test */
  proc testName() {
      var sc1 = new SmogReport();
      assertStringEquals("Default name is set", expected="Smog Report", actual=sc1.name);
      var sc2 = new SmogReport("Frank the Smog Report");
      assertStringEquals("Intializer name is set", expected="Frank the Smog Report", actual=sc1.name);
  }

  proc run() {
    testName(); // register your proc in main
    return 0;
  }
}

/* The main routine to call the tests */
proc main(args: [] string) : int {
  var t = new SmogReportTest(verbose=true);
  var ret = t.run();
  t.report();
  return ret;
}
```

One way to run these is with `make`, as in

```
CC=chpl
MODULES=-M../src

smog: SmogTestTest.chpl
	$(CC) $(MODULES) -o smog $<; \
	./smog ; \
	rm smog
```

The do `make smog` and you should get the Output

```
make smog
chpl -M../src -o smog SmogTestTest.chpl; \
	./smog
 ** PASSED  ... Default name is set (AssertIntEquals)  - expected: Smog Report <-> Smog Report actual:
 ** FAILED  ... Intializer name is set (AssertIntEquals)  - expected: Frank the Smog Report <-> Smog Report actual:
 ** Passing: 1	Failing: 1
```
