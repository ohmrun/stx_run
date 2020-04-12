package stx.run.pack.task.term;

class Count extends Base{
  var count : Ref<Int>;
  public function new(count){
    super();
    this.count = count;
  }
  override private function do_pursue():Bool{
    return this.count.value > 0;
  }
}