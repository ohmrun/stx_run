package stx.run.test;

import stx.run.pack.task.term.Deferred;
import stx.run.pack.task.term.Base;

class TaskTest extends utest.Test{
  public function test(){
    var has_been_called : Ref<Bool> = false;
    var task = new SimpleTask(has_been_called);
    
    Assert.same(task.progress.data,Pending);
        task.pursue();
    Assert.same(task.progress.data,Secured);
    Assert.isTrue(has_been_called.value);

    var a = false;
    var task = Task.Anon(
      () -> a = true
    );

    Assert.same(Pending,task.progress.data);
      task.pursue();
    Assert.same(Secured,task.progress.data);
    Assert.isTrue(a);
  }
  public function test_deferred_sync(){
    var hbc : Ref<Bool> = false;

    var sync_reactor = Reactor.pure(
      new SimpleTask(hbc).asTaskApi()
    );
    var task = new Deferred(sync_reactor);
    Assert.same(Pending,task.progress.data);
        task.pursue();
    Assert.same(Secured,task.progress.data);
  }
  public function test_deferred_async(async:Async){
    var task = new DeferredSimpleTask(async).asTaskApi();
    var async_reactor = Reactor.into(
      (cb) -> {
        __.log().close().trace('cb called: ${task.progress.data}');
        Act.Delay(20).apply(()->{}).map(
          (_) -> {
            __.log().close().trace('after_wait: ${task.progress.data}');
            return task;
          }
        ).upply(cb);
      }
    );
    var task = new Deferred(async_reactor);
    Assert.same(Pending,task.progress.data);
        task.pursue();
    switch(task.progress.data){
      case Waiting(rct) : rct.upply(
        (_) -> Assert.pass()
      );
      default:
    }
    Assert.isTrue(task.ongoing);
        task.pursue();
    Assert.same(Polling(240),task.progress.data);//TODO is this a bug?

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
    return false;
  }
}