/* Documentation for Charcoal */
module Charcoal {
  use Reflection;

  class UnitTest {

    var s: int,   // Number of passing tests
        f: int,   // Number of failing tests
        t: int,   // Number of tests total
        verbose: bool = false,
        results: [1..0] TestResult;

    proc setUp() {}
    proc tearDown() {}

    proc init(verbose:bool=false) {
      this.s = 0;
      this.f = 0;
      this.verbose=verbose;
    }

    proc report() {
      for r in this.results {
        if this.verbose || !r.passed {
          writeln(r.report());
        }
        if r.passed {
          this.s += 1;
        } else {
          this.f += 1;
        }
        this.t += 1;
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
      const r = new TestIntResult(msg=msg, passed=b, expected, actual);
      this.results.push_back(r);
      return r;
    }

    proc assertRealEquals(msg: string, expected: real, actual: real) : TestResult {
      var b:bool = actual == expected;
      const r = new TestRealResult(msg=msg, passed=b, expected=expected, actual=actual);
      this.results.push_back(r);
      return r;
    }

    proc assertRealApproximates(msg: string, expected: real, actual: real) : TestResult {
      var d = abs(expected - actual);
      var b:bool = (d < 1.0e-5);
      const r = new TestRealApproximatesResult(msg=msg, passed=b, expected=expected
        , actual=actual, delta=d);
      this.results.push_back(r);
      return r;
    }

    proc assertArrayEquals(msg: string, expected: []?, actual: []?) : TestResult {
      const r = new TestArrayResult(msg=msg, passed=actual.equals(expected), expected, actual);
      this.results.push_back(r);
      return r;
    }

    proc assertIntArrayEquals(msg: string, expected: [] int, actual: [] int) : TestResult {
      const r = new TestIntArrayResult(msg=msg, passed=actual.equals(expected), expected, actual);
      this.results.push_back(r);
      return r;
    }

    proc assertThrowsError(msg: string, passed: bool = false, err: Error ) : TestResult {
      const r = new TestErrorResult(msg=msg, passed=passed, err=err);
      this.results.push_back(r);
      return r;
    }

    proc assertBoolEquals(msg: string, expected: bool, actual: bool) {
      const r = new TestBoolResult(msg=msg, passed=(expected==actual), expected=expected, actual=actual);
      this.results.push_back(r);
      return r;
    }

    proc assertStringEquals(msg: string, expected: string, actual: string) {
      const r = new TestStringResult(msg=msg,passed=(expected==actual),expected=expected, actual=actual);
      this.results.push_back(r);
      return r;
    }

    proc assertStringArrayEquals(msg: string, expected: [] string, actual: [] string) : TestResult {
      const r = new TestStringArrayResult(msg=msg, passed=actual.equals(expected), expected, actual);
      this.results.push_back(r);
      return r;
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
        var t: string = "FAILED ";
        if this.passed then t= "PASSED ";
        var m: string = " ** " + t + " ... " + this.msg;
        return m;
      }
  }

  class TestErrorResult : TestResult {
    var err: Error;

    proc init(msg: string, passed:bool, err:Error){
      super.init(msg=msg, passed=passed);
      this.complete();
    }

    proc report() {
      return this.writeThis();
    }

    proc writeThis() {
      //var m = "\t ** %s TEST (AssertThrowsError) " + super.writeThis();
      var m = super.writeThis() + " (AssertThrowsError) ";
      return m;
    }
  }

  class TestIntResult : TestResult {
      var expected: int,
          actual: int;

      proc init(msg: string, passed: bool, expected: int, actual: int) {
        super.init(msg=msg, passed=passed);
        this.complete();
        this.expected = expected;
        this.actual = actual;
      }

      proc report(): string {
          return this.writeThis();
      }

      proc writeThis(): string {
        var m: string = super.writeThis() + " (AssertIntEqual)";
        m += " - expected: " + this.expected + " <-> " + this.actual + " actual: ";
        return m;
      }
  }

  class TestBoolResult : TestResult {
      var expected: bool,
          actual: bool;

      proc init(msg: string, passed: bool, expected: bool, actual: bool) {
        super.init(msg=msg, passed=passed);
        this.complete();
        this.expected = expected;
        this.actual = actual;
      }

      proc report(): string {
        return this.writeThis();
      }

      proc writeThis(): string {
        var m: string = super.writeThis() + " (AssertBoolEqual)";
        m += " - expected: " + this.expected + " <-> " + this.actual + " actual";
        return m;
      }
  }


  class TestRealResult : TestResult {
      var expected: real,
          actual: real;

      proc init(msg: string, passed: bool, expected: real, actual: real) {
        super.init(msg=msg, passed=passed);
        this.complete();
        this.expected = expected;
        this.actual = actual;
      }

      proc report(): string {
        return this.writeThis();
      }

      proc writeThis(): string {
        var m: string = super.writeThis() + " (AssertRealEquals)";
        m += " - expected: " + this.expected + " <-> " + this.actual + " actual";
        return m;
      }
  }

  class TestRealApproximatesResult : TestResult {
      var expected: real,
          actual: real,
          delta: real;

      proc init(msg: string, passed: bool, expected: real, actual: real, delta:real) {
        super.init(msg=msg, passed=passed);
        this.complete();
        this.expected = expected;
        this.actual = actual;
        this.delta=delta;
      }

      proc report(): string {
        return this.writeThis();
      }

      proc writeThis(): string {
        var m: string = super.writeThis() + " (AssertRealApproximates)";
        //var m: string = "\t ** TEST (AssertRealApproximates) " + super.writeThis();
        m += " - expected: " + this.expected + " <-> " + this.actual + " actual";
        m += " delta: " + this.delta;
        return m;
      }
  }


  class TestArrayResult : TestResult {
    var expected: [1..0] real,
        actual: [1..0] real;

    proc init(msg: string, passed: bool, expected: [] real, actual: [] real) {
      super.init(msg=msg, passed=passed);
      this.complete();
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
      var m: string = super.writeThis() + " (AssertArrayEquals) ";
      m += " Expected: " + this.expected:string + " Actual: " + this.actual:string;
      return m;
    }
  }


  class TestStringResult : TestResult {
      var expected: string,
          actual: string;

      proc init(msg: string, passed:bool, expected: string, actual: string) {
        super.init(msg=msg, passed=passed);
        this.complete();
        this.expected = expected;
        this.actual = actual;
      }

      proc report(): string {
          return this.writeThis();
      }

      proc writeThis(): string {
        var m: string = super.writeThis() + " (AssertIntEquals) ";
        m += " - expected: " + this.expected + " <-> " + this.actual + " actual: ";
        return m;
      }
  }

  class TestIntArrayResult : TestResult {
    var expected: [1..0] int,
        actual: [1..0] int;

    proc init(msg: string, passed: bool, expected: [] int, actual: [] int) {
      super.init(msg=msg, passed=passed);
      this.complete();
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
      var m: string = super.writeThis() + " (AssertIntArrayEquals) ";
      msg += " Expected: " + this.expected:string + " Actual: " + this.actual:string;
      return m;
    }
  }


    class TestStringArrayResult : TestResult {
      var expected: [1..0] string,
          actual: [1..0] string;

      proc init(msg: string, passed: bool, expected: [] string, actual: [] string) {
        super.init(msg=msg, passed=passed);
        this.complete();
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
        var m: string = super.writeThis() + " (AssertStringArrayEquals) ";
        msg += " Expected: " + this.expected:string + " Actual: " + this.actual:string;
        return m;
      }
    }
}
