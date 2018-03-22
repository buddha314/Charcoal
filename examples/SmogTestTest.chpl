use thingiesToTest,
    Charcoal;

class SmogReportTest: UnitTest {

  proc setUp() {}
  proc tearDown() {}

  proc init(verbose:bool) {
    super.init(verbose=verbose);
    this.complete();
  }


  proc testName() {
      var sc1 = new SmogReport();
      assertStringEquals("Default name is set", expected="Smog Report", actual=sc1.name);
      var sc2 = new SmogReport("Frank the Smog Report");
      assertStringEquals("Intializer name is set", expected="Frank the Smog Report", actual=sc1.name);
  }

  proc run() {
    testName();
    return 0;
  }
}

proc main(args: [] string) : int {
  var t = new SmogReportTest(verbose=true);
  var ret = t.run();
  t.report();
  return ret;
}
