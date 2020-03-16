package stx.run.pack.uio;

class Implementation{
  static public inline function inj<T>(self:UIO<T>) return Constructor.ZERO;

  static public function map<T,TT>(self:UIO<T>,fn:T->TT):UIO<TT>                        return inj(self)._.map(fn,self);
  static public function fmap<T,TT>(self:UIO<T>,fn:T->UIO<TT>):UIO<TT>                  return inj(self)._.fmap(fn,self);
  static public function attempt<T,TT,E>(self:UIO<T>,fn:T->Outcome<TT,E>):IODef<TT,E>   return inj(self)._.attempt(fn,self);
  static public function command<T>(self:UIO<T>,cb:T->Void):UIO<T>                      return inj(self)._.command(cb,self);

  static public function toIO<T>(self:UIO<T>):IO<T,Dynamic>                             return self.toIO(); 
}