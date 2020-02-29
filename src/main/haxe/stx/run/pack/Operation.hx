package stx.run.pack;

typedef OperationT<R,E> = Unary<Op,Chomp<R,E>>;

@:callable abstract Operation<R,E>(OperationT<R,E>) from OperationT<R,E> to OperationT<R,E>{
  public function new(self) this = self;
  static public function lift<R,E>(self:OperationT<R,E>):Operation<R,E> return new Operation(self);
  

  public function mod<RI,EE>(f1:Unary<Chomp<R,E>,Chomp<RI,EE>>):Operation<RI,EE>{
    return this.then(f1);
  }

  public function prj():OperationT<R,E> return this;
  private var self(get,never):Operation<R,E>;
  private function get_self():Operation<R,E> return lift(this);
}