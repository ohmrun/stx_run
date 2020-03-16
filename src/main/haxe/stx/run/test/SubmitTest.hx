package stx.run.test;


class SubmitTest extends utest.Test{
  @:timeout(1000)
  public function test_submit(async:Async){
    trace("test");
    Act.Defer().upply(
      () -> {
        Assert.pass();
        async.done();
      }
    );
  }
}