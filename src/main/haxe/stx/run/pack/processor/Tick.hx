package stx.run.pack.processor;

typedef Tick = TickSum;
/**
  TODO Assuming ticks are well behaved. Need to set up a Backoff
  algorithm
**/
enum TickSum{
  Busy(wake:(Void->Void) -> Void);
  Poll(?milliseconds:MilliSeconds);
  Fail(e:Err<Dynamic>);
  Exit;
}