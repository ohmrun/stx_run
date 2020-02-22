package stx.arrowlet.core.pack;

import stx.run.head.data.Continue in ContinueT;

@:forward abstract Continue<T>(ContinueT<T>) from ContinueT<T>{
  @:noUsing static public function unit<T>():Continue<T>{
    return {
      apply : (v:T) -> {
        return new stx.runloop.pack.Anonymous(()->{},()->{});
      }
    }
  }
  @:noUsing static public function pure<T>(fn:T->Void):Continue<T>{
    return {
      apply : (v:T) -> new Anonymous(fn.bind(v),()->{})
    };
  }
  @:from @:noUsing static public function fromFunction<T>(fn:T->Task<Noise>):Continue<T>{
    return {
      apply : fn
    };
  }
  public function new(self:ContinueT<T>){
    this = self;
  }
}
