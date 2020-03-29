package stx.run.type;

typedef RecallDef<I,O,R>  = {
  public function applyII(i:I,cb:Sink<O>):R;
  public function asRecallDef():RecallDef<I,O,R>;
}