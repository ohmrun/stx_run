package stx.run.pack.chomp;

import stx.run.pack.Chomp;

enum Enum<R,E>{
  Interim(v: Receiver<Chomp<R,E>>);//event architecture
  Operate(ch: Unary<Op,Chomp<R,E>>);//thread architecture
  Release(v:R);//completion
  Default(e:TypedError<E>);//error
}