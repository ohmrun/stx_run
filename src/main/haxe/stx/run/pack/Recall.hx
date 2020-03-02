package stx.run.pack;

import stx.run.pack.recall.term.Anon;
import stx.run.pack.recall.term.Pure;

@:forward abstract Recall<I,O,R>(RecallDef<I,O,R>) from RecallDef<I,O,R> to RecallDef<I,O,R>{
  static public inline function pure<I,O,R>(o:O):Recall<I,O,R>{
    return new Pure(o);
  }
  static public inline function anon<I,O,R>(fn:RecallFunction<I,O,R>):Recall<I,O,R>{
    return new Anon(fn);
  }
}