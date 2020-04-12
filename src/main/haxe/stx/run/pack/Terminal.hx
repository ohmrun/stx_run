package stx.run.pack;

import haxe.Timer;

import stx.run.pack.task.term.Count;
import stx.run.pack.task.term.Base;
import stx.run.pack.task.term.When;

class TerminalApiBase<O,E> extends When<O>{
  var forks     : Ref<Int>;
  var handles   : Array<Void->Void>;
  var children  : Array<Task>;

  public function new(){
    super();
    this.forks    = 0;
    this.handles  = [];
    this.children = [];
  }
  override public function do_escape(){
    for (child in this.children){
      child.escape();
    }
    super.escape();
  }
  override public function do_pursue(){
    __.log().close().trace('Terminal#do_pursue');
    for(handle in handles){
      handle();
    }
    return super.do_pursue();
  }
  public function float():Response<E>{
    return until(Task.ZERO);
  }
	public function value(o:O):Response<E>{
    trigger.trigger(o);
    return until(this);
	}
	public function until(task:Task):Response<E>{
		return Response.until(
      Task.Seq(
        [
          Task.All(this.children.iterator()),
          task,
          this
        ].iterator()
      )
    );
	}
	public function error(e:Err<AutomationFailure<E>>):Response<E>{
		return until(new stx.run.pack.task.term.Error(e));
  }
  public function later(cb:Sink<O>):Response<E>{
    var inner : Void -> Void = null;
        inner = () -> {
          this.trigger.handle(cb);
          this.handles.remove(inner);
        }
    this.handles.push(inner);
    
    return until(this);
  }
  public function fork<T>(join:Sink<T>):Terminal<T,E>{
    var next = new TerminalApiBase();
        next.later(
          (v) -> {
            __.log().close().trace("JOIN");
            join(v);
          }
        );
    this.children.push(next);
    return next;
  }
	public function asTerminalDef():TerminalDef<O,E>{
		return this;
  }
}
typedef TerminalDef<O,E> = {
  public function float():Response<E>;
	public function until(task:Task):Response<E>;
	public function value(o:O):Response<E>;
  public function error(e:Err<AutomationFailure<E>>):Response<E>;
  public function later(cb:O->Void):Response<E>;

  public function fork<T>(cb:Sink<T>):Terminal<T,E>;

	public function asTerminalDef():TerminalDef<O,E>;
}
@:forward abstract Terminal<O,E>(TerminalDef<O,E>) from TerminalDef<O,E> to TerminalDef<O,E>{
	static public function unit<O,E>():Terminal<O,E>{
		return new TerminalApiBase().asTerminalDef();
	}
}
