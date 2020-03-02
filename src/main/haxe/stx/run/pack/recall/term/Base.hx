package stx.run.pack.recall.term;

@:using(stx.run.pack.recall.Implementation)
class Base<I,O,R> implements stx.run.type.Package.RecallInterface<I,O,R>{
  
  public function new(){
    
  }
  public function duoply(i:I,cb:(O -> Void)):R{
    return throw __.fault().of(Failure_AbstractMethod);
  }

  public function prj():stx.run.type.Package.RecallInterface<I,O,R>{
    return this;
  }
}