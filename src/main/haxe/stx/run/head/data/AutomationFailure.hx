package stx.run.head.data;

enum AutomationFailure<EE>{
  UnknownAutomationError(e:Dynamic);
  HaltedAt(e:TypedError<EE>);
  Timeout(?float:Float);
}