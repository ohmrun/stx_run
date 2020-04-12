package stx.run.test;

@:access(stx) class TerminalTest extends utest.Test{
	//@Ignored
	public function test(async:utest.Async){
    var term          = new stx.run.pack.Terminal.TerminalApiBase();
    var order_correct = false;
		var next = term.fork(
			(val:Int) -> {
        order_correct = true;
			}
		);
		var response = term.later(
			(val:Int) -> {
				Rig.isTrue(order_correct);
				trace(Scheduler.ZERO);
        async.done();
			}
		);
		response.submit();

		term.value(1);
		next.value(2);
	}
}