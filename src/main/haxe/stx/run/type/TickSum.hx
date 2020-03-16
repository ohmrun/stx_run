package stx.run.type;

enum TickSum{
  Exit;
  Poll(milliseconds:Float);
  Busy;
  Fail(e:TypedError<Dynamic>);
}