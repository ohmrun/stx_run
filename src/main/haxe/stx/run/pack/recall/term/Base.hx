package stx.run.pack.recall.term;

@:using(stx.run.pack.recall.Implementation)
class Base<I,O,R> implements RecallApi<I,O,R>{
  
  public function new(){
    
  }
  public function applyII(i:I,cb:(O -> Void)):R{
    return throw __.fault().of(E_AbstractMethod);
  }

  public function asRecallDef():RecallDef<I,O,R>{
    return this;
  }
}