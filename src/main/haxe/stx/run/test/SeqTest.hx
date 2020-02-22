package stx.runloop.test;

class SeqTest extends utest.Test{
	var log  : Log = __.log();
	public function testSeq(async:Async){
		var tasks = [
			Task.NOOP,
			Task.NOOP,
			new Anonymous(
				()-> {
					Assert.pass();
					async.done();
				},
				()->{}
			)
		];
		var seq = new Seq(
			tasks.toIter().toGenerator()
		);
		//log.debug('b4');
		RunLoop.current.work(seq);
	}
}