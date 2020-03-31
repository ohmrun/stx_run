import utest.UTest;
import utest.Runner;


using  stx.Run;

import stx.run.test.*;

using stx.Core;

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
			 .toArray()
		);
	}
}