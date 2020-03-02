package stx.run.pack.waiter;

//<T,E> implements stx.run.type.Package.Recall<Automation,Outcome<T,E>,Automation>
class Implementation{
    static public inline function inj<T,E>(self:WaiterDef<T,E>) return stx.run.pack.waiter.Constructor.ZERO;
  
    static public function map<T,TT,E>(self:WaiterDef<T,E>,fn:T->TT):WaiterDef<TT,E>                                       
      return inj(self)._.map(fn,self);
    static public function fmap<T,TT,E>(self:WaiterDef<T,E>,fn:T->WaiterDef<TT,E>):WaiterDef<TT,E>                            
      return inj(self)._.fmap(fn,self);
    static public function fold<T,TT,E>(self:WaiterDef<T,E>,val:T->TT,err:TypedError<E>->TT):ReceiverDef<TT>                 
      return inj(self)._.fold(val,err,self);
    static public function errata<T,E,EE>(self:WaiterDef<T,E>,fn:TypedError<E>->TypedError<EE>):WaiterDef<T,EE>            
      return inj(self)._.errata(fn,self);
}