package stx.run.type;

typedef RecallDef<I,O,R>  = {
  public function duoply(i:I,cb:Sink<O>):R;
  public function asRecallDef():RecallDef<I,O,R>;
}