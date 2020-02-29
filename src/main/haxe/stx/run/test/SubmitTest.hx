package stx.run.test;

class SubmitTest extends utest.Test{
  public function test_submit(async:Async){
    MainLoop.add(
      () -> {
        async.done();
      }
    );
  }
}