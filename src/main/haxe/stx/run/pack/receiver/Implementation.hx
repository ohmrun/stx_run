package stx.run.pack.receiver;

class Implementation{
  static public inline function inj<T>(self:Receiver<T>) return Constructor.ZERO;

  static public function apply<T>(self:Receiver<T>,cb:T->Void):Automation                     return inj(self)._.apply(cb,self);
  static public function command<T>(self:Receiver<T>,cmd:T->Void):Receiver<T>                 return map(self,__.command(cmd));
  static public function map<T,TT>(self:Receiver<T>,fn:T->TT):Receiver<TT>                    return inj(self)._.map(fn,self);
  static public function fmap<T,TT>(self:Receiver<T>,fn:T->Receiver<TT>):Receiver<TT>         return inj(self)._.fmap(fn,self); 

  static public function toWaiter<T>(self:Receiver<T>):Waiter<T,Dynamic>                      return inj(self)._.toWaiter(self);
  static public function toUIO<T>(self:Receiver<T>):UIODef<T>                                 return inj(self)._.toUIO(self);

}