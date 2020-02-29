package stx.run.head.data;

enum AutomationFailure<EE>{
  NoValueFound();
  UnknownAutomationError(e:Dynamic);
  StackOverflow;
  HaltedAt(e:TypedError<EE>);
  Timeout(?float:Float);
}