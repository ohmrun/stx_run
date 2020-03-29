package stx.run.type;

interface RecallApi<I,O,R> extends App2R<I,Sink<O>,R>{
  public function asRecallDef():RecallDef<I,O,R>;
}