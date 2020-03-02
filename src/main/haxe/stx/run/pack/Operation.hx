package stx.run.pack;

import stx.run.type.Package.Operation in OperationT;

@:callable abstract Operation<R,E>(OperationT<R,E>) from OperationT<R,E> to OperationT<R,E>{
  public function new(self) this = self;
  static public function lift<R,E>(self:OperationT<R,E>):Operation<R,E> return new Operation(self);
  
  @:noUsing static public function fromThunk<R,E>(fn:Void->Chomp<R,E>):Operation<R,E>{
    var err : TypedError<E> = cast __.fault().any('Escape');
    return lift(
      function(op:Op):Chomp<R,E>{
        return switch(op){
          case Pursue : fn();
          default     : Default(err);
        };
      }
    );
  }

  public function mod<RI,EE>(f1:Unary<Chomp<R,E>,Chomp<RI,EE>>):Operation<RI,EE>{
    return this.then(f1);
  }

  public function prj():OperationT<R,E> return this;
  private var self(get,never):Operation<R,E>;
  private function get_self():Operation<R,E> return lift(this);
}