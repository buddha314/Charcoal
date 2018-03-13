/* Documentation for Charcoal */
module Charcoal {

  class UnitTest {

    var s: int,   // Number of passing tests
        f: int,   // Number of failing tests
        t: int,   // Number of tests total
        results: [1..0] TestResult;

    proc init() {
      this.s = 0;
      this.f = 0;
    }

    proc report() {
      for r in this.results {
        writeln(" ** TEST: ", r.passed , " ... ", r.msg);
        if r.passed {
          this.s += 1;
        } else {
          this.f += 1;
        }
      }
      writeln("    Passing: ", this.s, "\tFailing: ", f);
    }

    proc run() {return 0;}

    proc assertIntEquals(msg: string, expected: []?, actual: []?) : TestResult {
      return TestResult(msg=msg, passed=(actual == expected), expected, actual);
    }

    proc assertArrayEquals(msg: string, expected: []?, actual: []?) : TestResult {
      return new TestArrayResult(msg=msg, passed=actual.equals(expected), expected, actual);
    }
  }

  class TestResult {
      var passed: bool = false,
          msg: string;

      proc init() {
        super.init();
        this.initDone();
      }

      /*
      proc init(passed:bool) {
        super.init();
        this.initDone();
        this.passed = passed;
      } */

      proc init(msg: string, passed:bool) {
        super.init();
        this.initDone();
      }
  }

  class TestArrayResult : TestResult {
    proc init(msg: string, passed: bool, expected: [] real, actual: [] real) {
      super.init();
      this.initDone();
      this.msg = msg;
      this.passed=passed;
    }

  }
}
