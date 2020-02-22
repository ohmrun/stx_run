package stx.run.head.data;

class Item{
  public var identity(default,null)     : Block;
  public var initialized(default,null)  : TimeStamp;
  public var last(default,null)         : TimeStamp;
  public var count(default,null)        : Int;

  public function new(identity){
    this.identity     = identity;
    //this.initialized  = TimeStamp.now();
  }
  // public function prod():Future<TaskState>{
    
  // }
}