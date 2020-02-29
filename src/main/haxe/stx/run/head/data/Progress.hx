package stx.run.head.data;

enum Progress{
  Pending;

  Unready;
  
  Polling(milliseconds:Int);
  
  Waiting(cb:Reactor<Noise>);

  Problem(e:TypedError<AutomationFailure<Dynamic>>);
  
  Reready;
  Already;
}