package stx.run.pack.reactor;


class Implementation{
  static public function inj<T>(self:ReactorDef<T>) return stx.run.pack.reactor.Constructor.ZERO;

  static public function upply<T>(self:ReactorDef<T>,cb:T->Void)                           return inj(self)._.upply(cb,self);
  
  static public function or<T>(self:ReactorDef<T>,that:ReactorDef<T>):ReactorDef<T>        return inj(self)._.or(that,self);
  static public function fmap<T,TT>(self:ReactorDef<T>,fn):ReactorDef<T>                   return inj(self)._.fmap(fn,self);
  static public function map<T,TT>(self:ReactorDef<T>,fn:T->TT):ReactorDef<TT>             return inj(self)._.map(fn,self);

  static public function toReceiver<T>(self:ReactorDef<T>):ReceiverDef<T>                  return inj(self)._.toReceiver(self);
}