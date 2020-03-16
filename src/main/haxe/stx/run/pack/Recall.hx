package stx.run.pack;

import stx.run.pack.recall.term.Anon;
import stx.run.pack.recall.term.Pure;

@:forward abstract Recall<I,O,R>(RecallDef<I,O,R>) from RecallDef<I,O,R> to RecallDef<I,O,R>{
  static public inline function _() return stx.run.pack.recall.Constructor.ZERO;
  @:deprecated
  static public inline function inj() return stx.run.pack.recall.Constructor.ZERO;

 
  public function fulfill(i:I):RecallDef<Noise,O,R>{
    return _()._.fulfill(i,self);
  }
  public function map<OO>(fn:O->OO):RecallDef<I,OO,R>{
    return _()._.map(fn,self);
  }
  public function map_r<RR>(fn:R->RR):RecallDef<I,O,RR>{
    return _()._.map_r(fn,self);
  }

  private var self(get,never):Recall<I,O,R>;
  private function get_self():Recall<I,O,R> return this;

  static public function fromThunk<T>(fn:Void->T):RecallDef<Noise,T,Void>       return _().fromThunk(fn);
  static public function fromNoiseThunk<T>(fn:Noise->T):RecallDef<Noise,T,Void> return _().fromNoiseThunk(fn);
  static public function pure<I,O,R>(o:O):RecallDef<I,O,R>                      return _().pure(o);
  static public function Anon<I,O,R>(fn:RecallFun<I,O,R>):RecallDef<I,O,R>      return _().Anon(fn);
}
