package stx.run.head;

import stx.run.head.data.Receiver in ReceiverT;
import stx.run.head.data.Continue in ContinueT;

class Continues{
  static public var _(default,null) = new stx.run.body.Continues();

  static public function lift<O>(cont:ContinueT<O>):Continue<O>  return new Continue(cont);
  static public function unit<O>():Continue<O>                   return lift((o:O,auto:Automation) -> auto);
}