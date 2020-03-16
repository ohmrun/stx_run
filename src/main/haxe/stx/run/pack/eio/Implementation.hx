package stx.run.pack.eio;

class Implementation{
    static public function inj<E>(self:EIO<E>) return new stx.run.pack.eio.Constructor();
  
    static public function fold<E,T>(self:EIO<E>,pure:TypedError<E>->T,zero:Thunk<T>):UIODef<T>                 return inj(self)._.fold(pure,zero,self);
    static public function mod<E,EE>(self:EIO<E>,fn:Report<E>->Report<EE>):EIO<EE>                              return inj(self)._.mod(fn,self);
    static public function errata<E,EE>(self:EIO<E>,fn:TypedError<E>->TypedError<EE>):EIO<EE>                   return inj(self)._.errata(fn,self);
  
  
    static public function toIO<E>(self:EIO<E>):IODef<Noise,E>                                                  return inj(self)._.toIO(self);
    static public function toUIO<E>(self:EIO<E>):UIODef<Report<E>>                                              return inj(self)._.toUIO(self);  
}