package stx.run.test;

import stx.run.pack.task.term.*;

class TaskAdvancedTest extends utest.Test{
  function sync_task(?on_pursue,?on_cancel){

  }
  function async_task(?on_pursue,?on_cancel){

  }
  @:timeout(10000)
  public function test_main_loop(async:utest.Async){
    Act.Delay(300).upply(
      () -> {
        Rig.pass();
        async.done();
      }
    );
  } 
}
class ChattyAnon extends Anon{
  override function do_pursue() {
    __.log()('pursue: $uuid');
    return super.do_pursue();
  }
  override function do_escape() {
    __.log()('escape: $uuid');
    super.do_escape();
  }
  override function do_cleanup() {
    __.log()('cleanup: $uuid');
    super.do_cleanup();
  }
}