package stx.run.pack.uio;

class Implementation{
  static public inline function inj<T>(self:UIODef<T>) return Constructor.ZERO;

  static public function map<T,TT>(self:UIODef<T>,fn:T->TT):UIODef<TT>                       return inj(self)._.map(fn,self);
  static public function fmap<T,TT>(self:UIODef<T>,fn:T->UIODef<TT>):UIODef<TT>              return inj(self)._.fmap(fn,self);
  static public function attempt<T,TT,E>(self:UIODef<T>,fn:T->Outcome<TT,E>):IODef<TT,E>     return inj(self)._.attempt(fn,self);
  static public function command<T>(self:UIODef<T>,cb:T->Void):UIODef<T>                     return inj(self)._.command(cb,self);

  static public function toIO<T>(self:UIODef<T>):IODef<T,Dynamic>                            return IO.inj().fromUIOT(self); 
}