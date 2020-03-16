package stx.run.type;

enum ProgressSum{
  Pending;

  Polling(milliseconds:Int);  
  Waiting(cb:Reactor<Noise>);

  Problem(e:TypedError<AutomationFailure<Dynamic>>);
  
  Escaped;
  Secured;
}