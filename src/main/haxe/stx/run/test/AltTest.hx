package stx.runloop.test;

class AltTest extends utest.Test{
  public function testBasicAlt(async:Async){
    var val = 0;
    var a   = new Anonymous(
      () -> {
        val = 1;
        trace("1");
      },
      () -> {}
    );
    var b   = new Anonymous(
      () -> {
        val = 2;
        trace("2");
      },
      () -> {}
    );
    var alt = new Alt(
      ([a,b]:Array<Task>).prj().toIter().toGenerator()
    );
    RunLoop.current.work(alt);
  }
}