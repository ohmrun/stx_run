package stx.run;

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
				//new TaskAdvancedTest(),
				
				//new GreedyTaskTest(),
				//new ReceiverTest(),
				//new SubmitTest(),
				//new ScheduleTest(),		

				//new SeqTest(),
				//new DeferredTest()
				//new SchedulerTest(),
				//new TaskTest(),	
				new CoroutineTest(),
			].last().toArray()
		);
  }
}
class CoroutineTest extends utest.Test{
	public function est_stat_creation(){
		var l 			= Act.Delay(300).reply().map(_ -> Success(2));
		var lt	  	= Job.defer(l);
		var agenda 	= lt.serve();
	}
	@:timeout(6000)
	public function test(async:utest.Async){
		var l 		= Act.Delay(300).reply().map(_ -> Success(2));
		var r 		= Act.Delay(500).reply().map(_ -> Success(3));
		var lt 		= Job.defer(l)
		.later(
			(x) -> trace(x)
		).serve();
		var rt 		= Job.defer(r)
		.later(
			(x) -> trace(x)
		).serve();
		var par 	= lt.par(rt);

		function handler(par){
			switch(par){
				case Hold(ft) 				: ft().handle(handler);
				case Emit(head,tail)	:
					trace(head);
					handler(tail);
				case Wait(fn) 				: handler(fn(Push(Noise)));
				case Halt(res) 				:
					trace(res);
					async.done();
				default:
			}
		}
		handler(par);
	}
}