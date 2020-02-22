package stx.run.head.data;

enum TaskState{
  Busy(waiting:Waiting);
  Done(err:Option<TypedError<AutomationFailure<Dynamic>>>);
}