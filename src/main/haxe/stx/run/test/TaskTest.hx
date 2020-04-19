package stx.run.test;

import stx.run.pack.task.term.Deferred;
import stx.run.pack.task.term.Base;

class TaskTest extends utest.Test{
  public function test(){
    var has_been_called : Ref<Bool> = false;
    var task = new SimpleTask(has_been_called);
    
    Rig.same(task.progress.data,Pending);
        task.pursue();
    Rig.same(task.progress.data,Secured);
    Rig.isTrue(has_been_called.value);

  }
  public function test_anon(){
    var a = false;
    var task = Task.Anon(
      () -> a = true
    );

    Rig.same(Pending,task.progress.data);
      task.pursue();
    Rig.same(Secured,task.progress.data);
    Rig.isTrue(a);
  }
  public function test_deferred_sync(){
    var hbc : Ref<Bool> = false;

    var sync_reactor = Future.sync(
      new SimpleTask(hbc).asTaskApi()
    );
    var task = new Deferred(sync_reactor);
    Rig.same(Pending,task.progress.data);
        task.pursue();
    Rig.same(Secured,task.progress.data);
  }
  @:timeout(2000)
  public function test_deferred_async(async:Async){
    var task          = new DeferredSimpleTask(async).asTaskApi();
    var async_reactor = Future.async(
      (cb) -> {
        //__.log().trace('cb called: ${task.progress.data}');
        Act.Delay(300).reply().map(
          (_) -> {
          //  __.log().trace('after_wait: ${task.progress.data}');
            return task;
          }
        ).handle(cb);
      }
    );
    var task = new Deferred(async_reactor);
    Rig.same(Pending,task.progress.data);
        task.pursue();
    switch(task.progress.data){
      case Waiting(rct) : rct.handle(
        (_) -> Rig.pass()
      );
      default:
    }
    Rig.isTrue(task.progress.data.ongoing);
        task.pursue();
    
    Rig.same(Polling(200),task.progress.data);

  }
}
private class DeferredSimpleTask extends Base{
  var async : utest.Async;
  public function new(async){
    super();
    this.async = async;
  }
  override function do_pursue(){
    async.done();
    return false;
  }
}
private class SimpleTask extends Base{
  var has_been_called : Ref<Bool>;
  public function new(ref){
    super();
    this.has_been_called = ref;
  }
  override function do_pursue(){
    this.has_been_called.value = true;
    progression(Secured);
    return false;
  }
}