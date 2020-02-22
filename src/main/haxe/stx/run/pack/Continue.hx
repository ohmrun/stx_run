package stx.run.pack;

import stx.run.head.data.Receiver in ReceiverT;
import stx.run.head.data.Continue in ContinueT;

@:forward @:callable abstract Continue<O>(ContinueT<O>) from ContinueT<O>{
  public function new(self) this = self;

  static public function lift<O>(cont:ContinueT<O>):Continue<O>   return Continues.lift(cont);
  static public function unit<O>():Continue<O>                    return Continues.unit();  

  public function command(cb:O->Void):Continue<O>                 return Continues._.command(self,cb);
  
  
  
  private var self(get,never):Continue<O>;
  private function get_self():Continue<O> return lift(this);

  public function prj():ContinueT<O> return this;

}