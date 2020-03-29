package stx.run.pack.io;

class Implementation{
  static public inline function inj<T,E>(self:IO<T,E>)                                            return Constructor.ZERO;
  
  static public function map<T,TT,E>(self:IO<T,E>,fn:T->TT):IO<TT,E>                              return inj(self)._.map(fn,self);
  static public function fmap<T,TT,E>(self:IO<T,E>,fn:T->IO<TT,E>):IO<TT,E>                       return inj(self)._.fmap(fn,self);
  static public function fold<T,TT,E>(self:IO<T,E>,v:T->TT,e:Null<Err<E>>->TT):UIO<TT>     return inj(self)._.fold(v,e,self);
  static public function zip<T,TT,E>(self:IO<T,E>,that:IO<TT,E>):IO<Couple<T,TT>,E>               return inj(self)._.zip(that,self); 
  static public function errata<T,E,EE>(self:IO<T,E>,fn:Err<E>->Err<EE>):IO<T,EE>   return inj(self)._.errata(fn,self);
  static public function wait<T,E>(self:IO<T,E>,?auto:Automation):WaiterDef<T,E>                  return inj(self)._.wait(auto,self);
  static public function point<T,E>(self:IO<T,E>,fn:T->EIO<E>):EIO<E>                             return inj(self)._.point(fn,self);
  static public function elide<T,E>(self:IO<T,E>):IO<Any,E>                                       return inj(self)._.elide(self);

  //public function export<I,O>(fn:R->Channel<I,O,E>):Channel<I,O,E>            return inj()._.export(fn,self);

  //public function then<O>(arw:Channel<R,O,E>):Proceed<O,E>{
    //return Proceeds.fromIO(self).then(arw);
  //}
}