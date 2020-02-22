package stx.run.head;

import stx.run.head.data.IO in IOT;

class IOs{
  static public var _(default,null) = new stx.run.body.IOs();
  @:noUsing static public inline function lift<R,E>(io:IOT<R,E>){
    return new IO(io);
  }
  @:noUsing static public inline function pure<R>(v:R):IO<R,Noise>{
    return fromThunk(() -> v);
  }
  @:noUsing static public inline function fromUIOT<O>(fn:Automation->((O->Void)->Automation)):IO<O,Noise>{
    return lift((auto:Automation) -> (next:Chunk<O,Noise>->Void) -> {
      return fn(auto)(
        (o) -> {
          next(Val(o));
        }
      );
    });
  }
  @:noUsing static public inline function fromIOT<O,E>(fn:Automation->((Chunk<O,E>->Void)->Automation)):IO<O,E>{
    return lift((auto:Automation) -> (next:Chunk<O,E>->Void) -> {
      return fn(auto)(
        (o) -> {
          next(o);
        }
      );
    });
  }
  @:noUsing static public inline function fromChunkThunk<R,E>(chk:Thunk<Chunk<R,E>>):IO<R,E>{
    return lift((auto) -> __.of(chk()).wait().prj());
  }
  @:noUsing static public inline function fromChunk<R,E>(chk:Chunk<R,E>):IO<R,E>{
    return lift((auto) -> __.of(chk).wait().prj());
  }
  @:noUsing static public inline function fromOutcomeThunk<R,E>(chk:Thunk<Outcome<R,TypedError<E>>>):IO<R,E>{
    return fromChunkThunk(
      chk.then(Chunks.fromOutcome)
    );
  }
  @:noUsing static public inline function fromOutcome<R,E>(chk:Outcome<R,TypedError<E>>):IO<R,E>{
    return fromChunk(
      Chunks.fromOutcome(chk)
    );
  }
  @:noUsing static public inline function fromThunk<R>(thk:Thunk<R>):IO<R,Noise>{
    return fromChunkThunk(thk.then(Val));
  }
  @:noUsing static public inline function fromOption<R>(opt:Option<R>):IO<R,Noise>{
    return fromChunk(Chunks.fromOption(opt));
  }
  @:noUsing static public inline function fromOptionThunk<R>(thk:Thunk<Option<R>>):IO<R,Noise>{
    return fromChunkThunk(thk.then(
      (opt) -> Chunks.fromOption(opt)
    ));
  }

  @:noUsing static public inline function bfold<A,E,R>(fn:A->R->IO<R,E>,arr:Array<A>,r:R):IO<R,E>{
    return arr.lfold(
      (next,memo:IO<R,E>) -> return memo.fmap((r:R) -> fn(next,r)),
      fromChunk(Val(r))
    );
  }
  @:noUsing static public inline function fromUnary<E,R>(fn:Unary<Noise,Chunk<R,E>>):IO<R,E>{
    return fromChunkThunk(fn.bind1(Noise));
  }
  @:noUsing static public inline function fromUnaryConstructor<E,R>(fn:Unary<Noise,IO<R,E>>):IO<R,E>{
    return lift((auto) -> fn(Noise)(auto));
  }
}