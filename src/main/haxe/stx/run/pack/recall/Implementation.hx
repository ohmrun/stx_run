package stx.run.pack.recall;

class Implementation{
  static public inline function inj<I,O,R>(self:Recall<I,O,R>)                      return Constructor.ZERO;
  static public function map<I,O,OO,R>(self:Recall<I,O,R>,fn:O->OO)                 return inj(self)._.map(fn,self);
  static public function fulfill<I,O,R>(self:Recall<I,O,R>,i:I):Recall<Noise,O,R>   return inj(self)._.fulfill(i,self);
  static public function deliver<I,O,R>(self:Recall<I,O,R>,cb:O->Void):I -> R       return inj(self)._.deliver(cb,self);
}