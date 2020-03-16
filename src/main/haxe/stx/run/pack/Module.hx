package stx.run.pack;

import stx.run.module.*;

class Module{
  public function new(){}
  public inline function bang():Bang{
    return Bang._().unit();
  }
}