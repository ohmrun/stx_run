import utest.UTest;
import utest.Runner;


using  stx.run.Pack;

import stx.run.test.*;

using stx.Core;
using stx.ds.Lift;

class Main {
	static function main() {
		trace("MAIN");
		UTest.run(
			[
				new SubmitTest(),
				new ReceiverTest(),
				new TaskTest(),
				new TaskAdvancedTest(),
			]
			 .last()
			 .array()
		);
	}
}