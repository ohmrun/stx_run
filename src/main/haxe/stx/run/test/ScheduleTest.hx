package stx.run.test;

import stx.run.pack.task.term.Deferred;
import stx.run.pack.task.term.Base in TaskBase;

class ScheduleTest extends utest.Test{
  public function test(){
    var bool : Ref<Bool>  = true;
    var task              = Task.Blocking(bool);
    var schedule          = Schedule.Task(task);
    Rig.same(Busy,schedule.status());
        schedule.pursue();
    Rig.same(Busy,schedule.status());
        bool.value        = false;
    Rig.same(Busy,schedule.status());
        schedule.pursue();
    Rig.same(Exit,schedule.status());
  }
  public function test0(){
    var bool : Ref<Bool>  = true;
    var task              = Task.Blocking(bool);
    var schedule          = Schedule.Task(task);
    Rig.same(Busy,schedule.status());
      schedule.pursue();
    Rig.same(Busy,schedule.status());
      bool.value        = false;
      schedule.pursue();
    Rig.same(Exit,schedule.status());
  }
  @:timeout(6000)
  public function test_waiting_deferred(async:Async){
    var bool : Ref<Bool>  = false;
    var task              = Task.Blocking(bool);
    var f                 = Future.trigger();
    var f0                = Future.trigger();
    var deferred          = new Deferred(f);
        deferred.pursue();
    trace(deferred.progress.data);
        deferred.pursue();
    trace(deferred.progress.data);
        deferred.pursue();
    trace(deferred.progress.data);
      Act.Delay(300).upply(
        () -> {
          f.trigger(task);
          deferred.pursue();
          trace(Scheduler.ZERO);
          Rig.same(Secured,deferred.progress.data);
          async.done();
        }
      );
  }
}