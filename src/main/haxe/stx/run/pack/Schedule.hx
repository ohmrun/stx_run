package stx.run.pack;

typedef ScheduleDef = Couple<Stat,Task>;

@:forward abstract Schedule(ScheduleDef) from ScheduleDef to ScheduleDef{
  static public function lift(self:ScheduleDef):Schedule{
    return new Schedule(self);
  }
  static public function pure(task:Task):Schedule{
    return lift(__.couple(Stat.pure(new Clock()),task));
  }
  public function new(self) this = self;
  public function value(){
    return this.fst().value();
  }
  public function progress(){
    return this.snd().progress.data;
  }
  public function is_less_than(that:Schedule):Bool{
    return switch([progress(),that.progress()]){
      case [Pending,Pending] : value() < that.value();
      default                : progress().is_less_than(that.progress());
    }
  }
  public function pursue(){
    this.fst().enter();
    this.snd().pursue();
    this.fst().leave();
  }
  public function escape(){
    this.snd().escape();
  }
}