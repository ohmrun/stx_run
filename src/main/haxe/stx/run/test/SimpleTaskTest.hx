package stx.runloop.test;

class SimpleTaskTest extends utest.Test{
	var log  : Log = __.log();

	public function testEnsureSimpleTaskCanBeConstructedAndRun(async:Async){
		var val = false;
		var anon = new Anonymous(
			() -> {
				val = true;
				val.isTrue();
				async.done();
			},
			()->{}
		);
		val.isFalse();
		RunLoop.current.work(anon);
	}
}