package stx.run.type;

enum ProgressSum{
  Pending;

  Polling(milliseconds:Int);  
  Waiting(cb:Reactor<Noise>);

  Problem(e:Err<AutomationFailure<Dynamic>>);
  
  Escaped;
  Secured;
}