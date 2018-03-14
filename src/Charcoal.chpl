/* Documentation for Charcoal */
module Charcoal {
  use Reflection;

  class UnitTest {

    var s: int,   // Number of passing tests
        f: int,   // Number of failing tests
        t: int,   // Number of tests total
        results: [1..0] TestResult;

    proc setUp() {}
    proc tearDown() {}

    proc init() {
      this.s = 0;
      this.f = 0;
    }

    proc report() {
      for r in this.results {
        writeln(r.report());
        if r.passed {
          this.s += 1;
        } else {
          this.f += 1;
        }
      }
      writeln(" ** Passing: ", this.s, "\tFailing: ", f);
    }

    proc run() {
      setUp();
      tearDown();
      return 0;
    }

    proc assertIntEquals(msg: string, expected: int, actual: int) : TestResult {
      var b: bool = false;
      if actual == expected then b = true;
      return new TestIntResult(msg=msg, passed=b, expected, actual);
    }

    proc assertRealEquals(msg: string, expected: real, actual: real) : TestResult {
      var b:bool = actual == expected;
      return new TestRealResult(msg=msg, passed=b, expected, actual);
    }

    proc assertArrayEquals(msg: string, expected: []?, actual: []?) : TestResult {
      return new TestArrayResult(msg=msg, passed=actual.equals(expected), expected, actual);
    }

    proc assertIntArrayEquals(msg: string, expected: [] int, actual: [] int) : TestResult {
      return new TestIntArrayResult(msg=msg, passed=actual.equals(expected), expected, actual);
    }

    proc assertThrowsError(msg: string, passed: bool = false, err: Error ) : TestResult {
      return new TestErrorResult(msg=msg, passed=passed, err=err);
    }
  }

  class TestResult {
      var msg: string,
          passed: bool = false;

      proc init() { }

      proc init(msg: string, passed:bool) {
        this.msg = msg;
        this.passed=passed;
      }

      proc report() : string {
          return this.writeThis();
      }

      proc writeThis() {
          var m: string = this.passed + " ... " + this.msg;
          return m;
      }
  }

  class TestErrorResult : TestResult {
    var err: Error;

    proc init(msg: string, passed:bool, err:Error){
      super.init(msg=msg, passed=passed);
      this.initDone();
    }

    proc report() {
      return this.writeThis();
    }

    proc writeThis() {
      var m = "\t ** TEST (AssertThrowsError) " + super.writeThis();
      //m += this.err.message();
      return m;
    }
  }

  class TestIntResult : TestResult {
      var expected: int,
          actual: int;

      proc init(msg: string, passed: bool, expected: int, actual: int) {
        super.init(msg=msg, passed=passed);
        this.initDone();
        this.expected = expected;
        this.actual = actual;
      }

      proc report(): string {
          return this.writeThis();
      }

      proc writeThis(): string {
        var m: string = "\t ** TEST (AssertIntEquals) " + super.writeThis();
        m += " - expected: " + this.expected + " <-> " + this.actual + " actual: ";
        return m;
      }
  }

  class TestRealResult : TestResult {
      var expected: real,
          actual: real;

      proc init(msg: string, passed: bool, expected: real, actual: real) {
        super.init(msg=msg, passed=passed);
        this.initDone();
        this.expected = expected;
        this.actual = actual;
      }

      proc report(): string {
        return this.writeThis();
      }

      proc writeThis(): string {
        var m: string = "\t ** TEST (AssertRealEquals) " + super.writeThis();
        m += " - expected: " + this.expected + " <-> " + this.actual + " actual";
        return m;
      }
  }

  class TestArrayResult : TestResult {
    var expected: [1..0] real,
        actual: [1..0] real;

    proc init(msg: string, passed: bool, expected: [] real, actual: [] real) {
      super.init(msg=msg, passed=passed);
      this.initDone();
      for e in expected {
        this.expected.push_back(e);
      }
      for a in actual {
        this.actual.push_back(a);
      }

    }

    proc report() {
      return this.writeThis();
    }

    proc writeThis(): string {
      var m: string = "\t ** TEST (AssertArrayEquals) " + super.writeThis();
      msg += " Expected: " + this.expected:string + " Actual: " + this.actual:string;
      return m;
    }
  }

  class TestIntArrayResult : TestResult {
    var expected: [1..0] int,
        actual: [1..0] int;

    proc init(msg: string, passed: bool, expected: [] int, actual: [] int) {
      super.init(msg=msg, passed=passed);
      this.initDone();
      for e in expected {
        this.expected.push_back(e);
      }
      for a in actual {
        this.actual.push_back(a);
      }

    }

    proc report() {
      return this.writeThis();
    }

    proc writeThis(): string {
      var m: string = "\t ** TEST (AssertArrayEquals) " + super.writeThis();
      msg += " Expected: " + this.expected:string + " Actual: " + this.actual:string;
      return m;
    }
  }
}
