package stx.run.pack;

class Lift{
  static public function run(__:Wildcard):Module{
    return new stx.run.Module();
  }
  static public function toVoid<I,O>(rc:RecallDef<I,O,Noise>):RecallDef<I,O,Void>{
    return Recall.Anon(
      function (i:I,cont:Sink<O>):Void {
        rc.applyII(i,cont);
      }
    );
  }
}