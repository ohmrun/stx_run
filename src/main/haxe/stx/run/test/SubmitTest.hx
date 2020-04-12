package stx.run.test;


class SubmitTest extends utest.Test{
  @:timeout(1000)
  public function test_submit(async:Async){
    Act.Defer().upply(
      () -> {
        Rig.pass();
        async.done();
      }
    );
  }
}