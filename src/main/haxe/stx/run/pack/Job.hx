package stx.run.pack;

typedef JobDef<R,E> = SourceDef<Stat,R,E>;

@:using(stx.run.pack.Job.JobLift)
abstract Job<R,E>(JobDef<R,E>) from JobDef<R,E> to JobDef<R,E>{
	public function new(self) this = self;
	static public var _(default,never) = JobLift;
	@:noUsing static public inline function lift<R,E>(self:JobDef<R,E>) return new Job(self);
	@:noUsing static public function unit(){
		return lift(__.stop());
	}

	@:noUsing static public function fromRes<R,E>(res:Outcome<R,E>):Job<R,E>{
		return lift(
			res.fold(
				(v) -> __.done(v),
				(e) -> __.fail(__.fault().of(e))
			)
		);
	}
	static public var ZERO(default,never) : Job<Dynamic,Dynamic> = unit();

	@:noUsing static public function zero<R,E>():Job<R,E>{
		return cast ZERO;
	}
	@:noUsing static public function lazy<R,E>(fn:Void->Outcome<R,E>){
		return lift(__.wait(Transmission.fromFun1R((_:Noise) -> issue(fn()))));
	}
	@:noUsing static public function issue<R,E>(res:Outcome<R,E>):Job<R,E>{
		return fromRes(res);
	}
	@:noUsing static public function defer<R,E>(future:Future<Outcome<R,E>>):Job<R,E>{
		var stat = Stat.unit();
		return lift(
			__.hold(
				() -> {
					stat.enter();
					return future.map(
					res -> {
							stat.leave();
							return __.emit(stat,__.upcast(issue(res)));
						}
					);
				}
			)
		);
	}
	@:noUsing static public function value<R,E>(r:R):Job<R,E>{
		return Job.issue(Success(r));
	}
	@:noUsing static public function error<R,E>(e:E):Job<R,E>{
		return Job.issue(Failure(e));
	}
	@:to public function toCoroutine():Coroutine<Noise,Stat,R,E>{
		return this;
	}
}
class JobLift{
	static private function lift<R,E>(self:JobDef<R,E>):Job<R,E> return Job.lift(self);
	static public function later<R,E>(self:Job<R,E>,res:Outcome<R,E>->Void):Job<R,E>{
		return lift(Coroutine._.mod(self,i -> Coroutine._.on_return(i,
			(ret) -> switch ret {
				case Production(v)									: res(Success(v));
				case Terminated(Stop)								:
				case Terminated(CauseSum.Exit(err))	: 
					err.data.flat_map(
						(f) -> f.fold(Some,(_) -> None)
					).map(Failure).fold(res,()->{});
			}
		)));
	}
	static public function serve<R,E>(self:Job<R,E>):Agenda<E>{
		return self.toAgenda();
	}
	static public inline function toAgenda<R,E>(self:Job<R,E>):Agenda<E>{
		return Agenda.fromJob(self);
	}
	static public function after<R,E>(self:Job<R,E>,sequence:Agenda<E>):Agenda<E>{
		return lift(Coroutine._.flat_map_r(__.upcast(sequence),(_) -> __.upcast(toAgenda(self))));
	}
	static public function cons<R,E>(self:Job<R,E>,res:Outcome<R,E>):Job<R,E>{
		var f = __.into(cons.bind(_,res));
		return lift(switch(self){
			case Emit(head,tail) 								: __.emit(head,tail.mod(f));
			case Wait(fn)												: __.wait(fn.mod(f));
			case Hold(held)											: __.hold(held.mod(f));
			case Halt(Terminated(Stop))					: res.fold(
				__.done,
				(e) -> __.fail(__.fault().of(e))
			);
			case Halt(Production(r))										:	 __.done(r);
			case Halt(Terminated(CauseSum.Exit(cause)))	: __.fail(cause);
		});
	}
}