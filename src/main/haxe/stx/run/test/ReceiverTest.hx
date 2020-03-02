package stx.run.test;

class ReceiverTest extends utest.Test{
  //@Ignored
  public function test(){
    var n = 0;
    var receiver = Receiver.inj().into(
      (cb) -> {
        __.log().close().trace('callback called');
        n++;
        cb(Noise);
      }
    );
    receiver.apply((_)->{});
    receiver.apply((_)->{});
    Assert.equals(1,n);
  }
  //@Ignored
  public function test_async0(async:utest.Async){
    __.log().close().trace('test_async0');
    var receiver = Receiver.inj().into(
      (cb) -> {
        __.log().close().trace('callback called');
        cb(Noise);
        Assert.pass();
        async.done();
      }
    );
    //receiver((_)->{});
    __.run().defer(receiver.apply.bind((_)->{}));
  }

  public function test_async1(async:utest.Async){
    __.log().close().trace('test_async0');
    var receiver = Receiver.inj().into(
      (cb) -> {
        __.log().close().trace('callback called');
        __.run().defer(cb.bind(Noise));
      }
    );
    //receiver((_)->{});
    __.run().defer(receiver.apply.bind((_)->{
      Assert.pass();
      async.done();
    }));
  }
}
