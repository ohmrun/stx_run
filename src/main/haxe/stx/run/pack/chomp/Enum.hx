package stx.run.pack.chomp;

import stx.run.pack.Chomp;

enum Enum<R,E>{
  Interim(rcv: Reactor<Chomp<R,E>>);//event architecture
  Operate(f1: Operation<R,E>);//thread architecture


  Release(r:R);//completion
  Default(e:TypedError<E>);//error
}
/**
  return switch self {
      case Interim(rcv)           : 
      case Operate(f1)            :
      case Release(r)             :
      case Default(e)             :
    }
**/