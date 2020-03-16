package stx.run.pack.reactor;


class Implementation{
  static public function inj<T>(self:Reactor<T>)  return stx.run.pack.reactor.Constructor.ZERO;

  static public function upply<T>(self:Reactor<T>,cb:T->Void)                         return inj(self)._.upply(cb,self);
  
  static public function or<T>(self:Reactor<T>,that:Reactor<T>):Reactor<T>            return inj(self)._.or(that,self);
  static public function fmap<T,TT>(self:Reactor<T>,fn):Reactor<T>                    return inj(self)._.fmap(fn,self);
  static public function map<T,TT>(self:Reactor<T>,fn:T->TT):Reactor<TT>              return inj(self)._.map(fn,self);

  static public function toReceiver<T>(self:Reactor<T>):ReceiverDef<T>                return inj(self)._.toReceiver(self);
}