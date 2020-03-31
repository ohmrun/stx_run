package stx.run.pack;

import stx.run.pack.recall.term.Anon;
import stx.run.pack.recall.term.Pure;

@:using(stx.run.pack.Recall.RecallLift)
@:forward abstract Recall<I,O,R>(RecallDef<I,O,R>) from RecallDef<I,O,R> to RecallDef<I,O,R>{
  static public var _(default,never) = RecallLift;

  static public function fromThunk<T>(fn:Void->T):RecallDef<Noise,T,Void>{
    return Anon((_,cont) -> cont(fn()));
  }
  static public function fromNoiseThunk<T>(fn:Noise->T):RecallDef<Noise,T,Void>{
    return Anon((_,cont) -> cont(fn(Noise)));
  }
  static public inline function pure<I,O,R>(o:O):RecallDef<I,O,R>{
    return new Pure(o);
  }
  static public inline function Anon<I,O,R>(fn:RecallFun<I,O,R>):RecallDef<I,O,R>{
    return new Anon(fn).asRecallDef();
  }
  private var self(get,never):Recall<I,O,R>;
  private function get_self():Recall<I,O,R> return this;
}
class RecallLift{
  static public function fulfill<I,O,R>(self:Recall<I,O,R>,i:I):Recall<Noise,O,R>{
    return Recall.Anon((_,cb) -> self.applyII(i,cb));
  }
  static public function deliver<I,O,R>(self:Recall<I,O,R>,cb:O->Void):I -> R{
    return (i) -> self.applyII(i,cb);
  }
  static public function map<I,O,OO,R>(self:Recall<I,O,R>,fn:O->OO):Recall<I,OO,R>{
    return Recall.Anon(
      (i,cont) -> self.applyII(i,
        (o)->cont(fn(o))
      )
    );
  }
  static public function map_r<I,O,R,RR>(self:Recall<I,O,R>,fn:R->RR):Recall<I,O,RR>{
    return Recall.Anon(
      (i,cont) -> fn(self.applyII(i,cont))
    );
  }
}