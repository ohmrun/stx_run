package stx.run.test;

class ReceiverTest extends utest.Test{
  //@Ignored
  public function test(){
    var n = 0;
    var receiver = Receiver.lift(
      (cb) -> {
        __.log().close().trace('callback called');
        n++;
        cb(Noise);
        return Automation.unit();
      }
    );
    receiver((_)->{});
    receiver((_)->{});
    Assert.equals(1,n);
  }
  //@Ignored
  public function test_async0(async:utest.Async){
    __.log().close().trace('test_async0');
    var receiver = Receiver.lift(
      (cb) -> {
        __.log().close().trace('callback called');
        cb(Noise);
        Assert.pass();
        async.done();
        return Automation.unit();
      }
    );
    //receiver((_)->{});
    __.run().defer(receiver.prj().bind((_)->{}));
  }

  public function test_async1(async:utest.Async){
    __.log().close().trace('test_async0');
    var receiver = Receiver.lift(
      (cb) -> {
        __.log().close().trace('callback called');
        __.run().defer(cb.bind(Noise));
        return Automation.unit();
      }
    );
    //receiver((_)->{});
    __.run().defer(receiver.prj().bind((_)->{
      Assert.pass();
      async.done();
    }));
  }
}
