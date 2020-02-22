package stx.run.body;

import stx.run.head.data.Receiver in ReceiverT;
import stx.run.head.data.Continue in ContinueT;

class Continues extends Clazz{

  public function command<O>(self:Continue<O>,cb:O->Void):Continue<O>{
    return Continue.lift(
      (o:O,auto:Automation) -> {
        cb(o);
        return self(o,auto);
      }
    );
  }
}
