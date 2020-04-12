package stx.run;

import stx.run.pack.task.term.Error;
import stx.run.pack.task.term.*;

import utest.UTest;
import utest.Runner;

using  stx.Nano;
using  stx.Run;

import stx.run.test.*;

using stx.Core;

class Test{
  static public function main(){
    UTest.run(
			[
				new TaskAdvancedTest(),
				new TaskTest(),	
				
				new GreedyTaskTest(),
				new ReceiverTest(),
				new TerminalTest(),
				new SubmitTest(),
				new ScheduleTest(),		

				new SeqTest(),
				new DeferredTest(),
			]
		);
  }
}