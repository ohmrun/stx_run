package stx.run.pack.recall.term;

class Never<I,O,R> extends stx.run.pack.recall.term.Base<I,O,R>{
  override public function duoply<T>(i:I,o:O->Void):R{
    return null;
  }
}