package stx.run.pack.io;

class Implementation{
  static public inline function inj<T,E>(self:IODef<T,E>)                                               return Constructor.ZERO;
  
  static public function map<T,TT,E>(self:IODef<T,E>,fn:T->TT):IODef<TT,E>                              return inj(self)._.map(fn,self);
  static public function fmap<T,TT,E>(self:IODef<T,E>,fn:T->IODef<TT,E>):IODef<TT,E>                    return inj(self)._.fmap(fn,self);
  static public function fold<T,TT,E>(self:IODef<T,E>,v:T->TT,e:Null<TypedError<E>>->TT):UIODef<TT>     return inj(self)._.fold(v,e,self);
  static public function zip<T,TT,E>(self:IODef<T,E>,that:IODef<TT,E>):IODef<Tuple2<T,TT>,E>            return inj(self)._.zip(that,self); 
  static public function errata<T,E,EE>(self:IODef<T,E>,fn:TypedError<E>->TypedError<EE>):IODef<T,EE>   return inj(self)._.errata(fn,self);
  static public function wait<T,E>(self:IODef<T,E>,?auto:Automation):WaiterDef<T,E>                     return inj(self)._.wait(auto,self);
  static public function point<T,E>(self:IODef<T,E>,fn:T->EIODef<E>):EIODef<E>                          return inj(self)._.point(fn,self);
  static public function elide<T,E>(self:IODef<T,E>):IODef<Any,E>                                       return inj(self)._.elide(self);

  //public function export<I,O>(fn:R->Channel<I,O,E>):Channel<I,O,E>            return inj()._.export(fn,self);

  //public function then<O>(arw:Channel<R,O,E>):Proceed<O,E>{
    //return Proceeds.fromIO(self).then(arw);
  //}
}