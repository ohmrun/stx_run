package stx.run.type;

import stx.run.pack.Automation in AutomationA;

class Package{}

typedef RecallFunction<I,O,R> = (i:I,cb:Sink<O>) ->R;

interface RecallInterface<I,O,R> {
  public function duoply(i:I,cb:Sink<O>):R;
  public function prj():Recall<I,O,R>;
}
typedef RecallDef<I,O,R> = {
  public function duoply(i:I,cb:Sink<O>):R;
  public function prj():Recall<I,O,R>;
}
typedef BangDef           = RecallDef<Noise,Noise,Void>;
typedef ReactorDef<T>     = RecallDef<Noise,T,Void>;
//
typedef ReceiverDef<T>    = RecallDef<Noise,T,AutomationA>;
typedef WaiterDef<T,E>    = RecallDef<Noise,Outcome<T,E>,AutomationA>;
typedef IODef<T,E>        = RecallDef<AutomationA,Outcome<T,E>,AutomationA>;
typedef UIODef<T>         = RecallDef<AutomationA,T,AutomationA>;
typedef EIODef<E>         = RecallDef<AutomationA,Report<E>,AutomationA>;


typedef Strand<T>       = T -> AutomationA -> AutomationA;
typedef Automation      = Chomp<Queue,AutomationFailure<Dynamic>>;
typedef Operation<R,E>  = Unary<Op,Chomp<R,E>>;

interface Task{
  public var progress(get,set): Progression;
  function get_progress():Progression;
  function set_progress(ts:Progression):Progression;

  public var working(get,null): Bool;
  function get_working():Bool;

  public var hanging(get,null): Bool;
  function get_hanging():Bool;

  
  public function pursue():Void;
  public function escape():Void;

  public function asTask():Task;
  public function asDeferred():Task;
}
typedef Limit = {
  @:optional var unchanged : Int;//how many times can the progression be unchanged before bailing out.

  @:optional var duration  : Int;//milliseconds how long can this process take in total ''.
  @:optional var hanging   : Int;//milliseconds how long can the progression be unchanged ''.
}