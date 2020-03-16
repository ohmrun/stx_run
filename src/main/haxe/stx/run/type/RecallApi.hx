package stx.run.type;

interface RecallApi<I,O,R> {
  public function duoply(i:I,cb:Sink<O>):R;
  public function asRecallDef():RecallDef<I,O,R>;
}