package stx.run.pack;


class Picker{
  var data : Array<Schedule>;
  public function new(){
    this.data = [];
  }
  public function pop():Schedule{
    return data.shift();
  }
  public function put(schedule:Schedule):Void{
    if(!data.contains(schedule)){
      this.data.push(schedule);
    }
    ArraySort.sort(this.data,eq);
  }
  private function eq(l:Schedule,r:Schedule):Int{
    return Math.round(l.value()  - r.value());
  }
  public function peek():Schedule{
    return data[0];
  }
  public function escape(){
    for(schedule in data){
      schedule.escape();
    }
  }
  public function is_defined(){
    return this.data.is_defined();
  }
  public function size(){
    return this.data.length;
  }
  public function toString():String{
    return this.data.join(",");
  }
}