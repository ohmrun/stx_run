package stx.run.announce;

enum AutomationFailure<E>{
  NoValueFound();
  UnknownAutomationError(e:Dynamic);
  StackOverflow;
  HaltedAt(e:TypedError<E>);
  Timeout(?float:Float);
}
enum Op{
  Pursue;
  Escape;
}
enum Progress{
  Pending;
  Unready;
  Polling(milliseconds:Int);  
  Waiting(cb:ReactorDef<Noise>);
  Problem(e:TypedError<AutomationFailure<Dynamic>>);
  Reready;
  Already;
}
enum Chomp<R,E>{
  Interim(rcv: ReactorDef<Chomp<R,E>>);//event architecture
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
typedef Corridor<S,A,R,E> = A -> (R->S->Chomp<R,E>) -> (E->Chomp<R,E>) -> S -> Chomp<R,E>;