package stx.run.test;

class SeqTest extends utest.Test{
	var log  : Log = __.log();
	public function test_seq(async:Async){
		trace(Scheduler.ZERO);
		var tasks = [
			Task.ZERO,
			Task.ZERO,
			Task.Anon(
				()-> {
					Rig.pass();
					async.done();
				},
				()->{}
			)
		];
		var seq = Task.Seq(
			tasks.iterator()
		);
		trace(Scheduler.ZERO);//log.debug('b4');
		Scheduler.put(Schedule.Task(seq));
	}
	@:timeout(6000)
	public function test_0(async:Async){
		trace(Scheduler.ZERO);
		var ok  = false;
		var ord = Task.Blocking(false).seq(
			Task.Anon(
				() -> {
					trace("SET OK");
					ok =  true;
				}
			)
		);
		Act.Delay(2000).upply(
      () -> {
				Rig.isTrue(ok);
        async.done();
      }
		);
		trace(Scheduler.ZERO);
		Scheduler.put(Schedule.Task(ord));
	}
}