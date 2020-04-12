package stx.run.test;

import utest.Assert in Rig;
import utest.Async;

class DeferredTest extends utest.Test{
  public function test_act_delay(async:Async){
    Act.Delay(
      200
    ).upply(
      () -> {
        Rig.pass();
        async.done();
      }
    );
  }
  @:timeout(6000)
  public function test_not_blocking(async:Async){
    trace('test_not_blocking');
    var ok                  = false;
    Scheduler.put(
      Schedule.Task(
        Task.Blocking(false).seq(
          Task.Anon(
            () -> {
              trace("SET OK");
              ok =  true;
            }
          )
        )
      )
    );
    Act.Delay(2000).upply(
      () -> {
        Rig.isTrue(ok);
        trace(Scheduler.ZERO);
        trace('RELEASE ${Scheduler.ZERO.status()}');
        async.done();
      }
    );
  }
  @:timeout(6000)
  public function test_blocking(async:Async){
    var blocked : Ref<Bool> = true;
    var blocking            = Task.Blocking(blocked);
    Scheduler.ZERO.put(
      Schedule.Task(blocking)
    );
    Act.Delay(500).upply(
      () -> {
        trace("UNBLOCK");
        trace(Timer.mark());
        blocked.value = false;
        Act.Delay(3000).upply(
          () -> {
            trace(Timer.mark());
            trace(Scheduler.ZERO);
            Rig.same(Exit,Scheduler.ZERO.status());
            async.done();
          }  
        );
      }
    );
  }
}