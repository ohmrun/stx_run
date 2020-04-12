package stx.run.test;

class GreedyTaskTest extends utest.Test{
  public function test(){
    var blocker : Ref<Bool> = true;
    var task                = Task.Blocking(blocker);
    var schedule            = Schedule.Task(task);
        schedule.pursue();
        schedule.pursue();
        schedule.pursue();
        schedule.pursue();
        schedule.pursue();
        schedule.pursue();
        schedule.pursue();//?

    Rig.pass();
  }
}