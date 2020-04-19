package stx.run;

import stx.run.pack.Processor.ScheduleItem
import stx.run.pack.task.term.Error;
import stx.run.pack.task.term.*;

import utest.UTest;
import utest.Runner;

using stx.Pico;
using stx.Nano;
using stx.Run;

import stx.run.test.*;

class Test{
  static public function main(){
    UTest.run(
			[
				//new TaskTest(),	
				//new TaskAdvancedTest(),
				
				
				//new GreedyTaskTest(),
				//new ReceiverTest(),
				//new SubmitTest(),
				//new ScheduleTest(),		

				//new SeqTest(),
				//new DeferredTest()
				new ProcessorTest()
			].last().toArray()
		);
  }
}
class ProcessorTest extends utest.Test{
	@Ignored
	public function test(){
		var done	 		= false;
		var processor = Processor.ZERO;
				processor.add(
					Task.Anon(
						() -> {
							done = true;
						}
					)
				);
				processor.run(new MyThreadyThread());
				
	}
	@Ignored
	public function test_wake(){
		var hold = Future.trigger();
		var proc = Processor.unit();
				proc.add(Task.On(hold));
				proc.run(new MySleepyThread());
				hold.trigger(Noise);
	}
	private function thread(){
		return new stx.run.pack.Processor.ThreadApiBase();
	}
	@Ignored
	@:timeout(2000)
	public function testThreadBase(async:utest.Async){
		var count  = 0;
		var thread = thread();
				thread.enter(
					(report) -> {
						count++;
						return switch([report,count]){
							default : Exit;
						}
					}
				);	
				Act.Delay(500).upply(
					() -> {
						Rig.equals(1,count);
						async.done();
					}
				);
	}
	@:timeout(2000)
	public function testThreadBase_Busy(async:utest.Async){
		var done  = false;
		var calls = 0;

		var waker = (cb) -> {
			Act.Defer().upply(
				() -> {
					done = true;
					cb();
				}
			);
		}
		var thread = thread();
				thread.enter(
					(report) -> {
						calls++;
						return switch(done){
							case false  : Busy(waker);
							case true 	: 
								Rig.equals(2,calls);
								async.done();
								Exit;
						}
					}
				);
	}
	public function test_lesser_of_two_Polls(){
		var t0 = new SetTaskStatusTask(Polling(10));
		var t1 = new SetTaskStatusTask(Polling(100));
		
	}
}
class MyThreadyThread{
	public function new(){}
	public function enter(fn:Report<Dynamic>->Tick):Void{
		Rig.same(Tick.Poll(null),fn(None));
		Rig.same(Tick.Exit,fn(None));
	}
}
class MySleepyThread extends Clazz{
	public function enter(fn:Report<Dynamic>->Tick):Void{
		var wake = fn(None);
		switch(wake){
			case Busy(wake) : 
				wake(
					() -> {
						Rig.pass();
					}
				);
			default : 
					Rig.fail("EROROR");
		}
	}
}
class SetTaskStatusTask implements stx.run.pack.Task.TaskApi{
	public var rtid(default,null): Void->Void;
	public var progress(get,set): Progression;
	
  function get_progress():Progression{
		return Progression.pure(this.prog);
	}
	function set_progress(ts:Progression):Progression{
		throw "Nope";
	}
	var prog : Ref<Progress>;

	public function new(prog){
		this.rtid = ()->{};
		this.prog = prog;
	}

  public function pursue():Void{}
  public function escape():Void{}

	public function asTaskApi():TaskApi{
		return this;
	}
}
