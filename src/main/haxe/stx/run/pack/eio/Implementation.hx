package stx.run.pack.eio;

class Implementation{
    static public function inj<E>(self:EIODef<E>) return new stx.run.pack.eio.Constructor();
  
    static public function fold<E,T>(self:EIODef<E>,pure:TypedError<E>->T,zero:Thunk<T>):UIODef<T>               return inj(self)._.fold(pure,zero,self);
    static public function mod<E,EE>(self:EIODef<E>,fn:Report<E>->Report<EE>):EIODef<EE>                         return inj(self)._.mod(fn,self);
    static public function errata<E,EE>(self:EIODef<E>,fn:TypedError<E>->TypedError<EE>):EIODef<EE>              return inj(self)._.errata(fn,self);
  
    static public function crunch<E>(self:EIODef<E>)                                                             return inj(self)._.crunch(self);
  
    static public function toIO<E>(self:EIODef<E>):IODef<Noise,E>                                                return inj(self)._.toIO(self);
    static public function toUIO<E>(self:EIODef<E>):UIODef<Report<E>>                                            return inj(self)._.toUIO(self);  
}