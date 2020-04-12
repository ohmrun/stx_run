package stx.run.pack;

typedef Next = NextSum;
enum NextSum{
  Busy;
  Poll(?milliseconds:MilliSeconds);
  Fail(e:Err<Dynamic>);
  Exit;
}
