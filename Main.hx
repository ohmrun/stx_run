import utest.UTest;
import utest.Runner;
import stx.run.Package;

import stx.run.test.*;

using stx.core.Lift;
using stx.ds.Lift;

class Main {
	static function main() {
		UTest.run(
			[
				new SubmitTest(),
				new TaskTest(),
				new ReceiverTest()
			].ds()
			 .last()
			 .array()
		);
	}
}