package stx.run.pack.receiver;

class Implementation{
  static public inline function inj<T>(self:ReceiverDef<T>) return Constructor.ZERO;

  static public function apply<T>(self:ReceiverDef<T>,cb:T->Void):Automation                    return inj(self)._.apply(cb,self);
  static public function command<T>(self:ReceiverDef<T>,cmd:T->Void):ReceiverDef<T>             return map(self,__.command(cmd));
  static public function map<T,TT>(self:ReceiverDef<T>,fn:T->TT):ReceiverDef<TT>                return inj(self)._.map(fn,self);
  static public function fmap<T,TT>(self:ReceiverDef<T>,fn:T->ReceiverDef<TT>):ReceiverDef<TT>  return inj(self)._.fmap(fn,self); 

  static public function toWaiter<T>(self:ReceiverDef<T>):WaiterDef<T,Dynamic>                  return inj(self)._.toWaiter(self);
  static public function toUIO<T>(self:ReceiverDef<T>):UIODef<T>                                return inj(self)._.toUIO(self);

}