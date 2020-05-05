package stx.run.pack;

typedef AgendaDef<E> = Source<Stat,Stat,E>;
@:using(stx.run.pack.Agenda.AgendaLift)
abstract Agenda<E>(AgendaDef<E>) from AgendaDef<E> to AgendaDef<E>{
	public function new(self) this = self;
	static public function lift<E>(self:AgendaDef<E>):Agenda<E> return new Agenda(self);
	

	@:from static public function fromJob<R,E>(job:Job<R,E>):Agenda<E>{
		var last = null;
		function rec(job:Job<R,E>):Agenda<E>{
			var f 		= __.into(rec);
			return lift(switch(job){
				case Emit(head,tail)												: 
					last = head;
					__.emit(head,tail.mod(f));
				case Wait(fn)																:
					__.wait(fn.mod(f));
				case Hold(ft)																:
					__.hold(ft.mod(f));
				case Halt(Production(_))  									:	
					__.done(last);
				case Halt(Terminated(Stop)) 								: 
					__.done(last == null ? Stat.unit() : last);
				case Halt(Terminated(CauseSum.Exit(e))) 		: 
					__.fail(e);
			});	
		}
		return rec(job);
	}
	@:from static public function fromFutureAgenda<E>(ft:Future<Agenda<E>>):Agenda<E>{
    return lift(__.hold(()-> ft.map(__.upcast)));
  }
	public function submit(scheduler){
		var eff : Effect<E> = Coroutine._.map_r(
			Coroutine._.map(this,_ -> Noise),
			_ -> Noise
		);
		eff.run().handle(
			(err) -> switch(err){
				case None											:
				case Some(Stop)								:
				case Some(CauseSum.Exit(err))	: haxe.MainLoop.runInMainThread(
					() -> {
						throw err;
					}
				);
			}
		);
	}
	
	@:to public function toCoroutine(){
		return __.upcast(this);
	}
}
class AgendaLift{
	static private function lift<E>(self:AgendaDef<E>):Agenda<E> return Agenda.lift(self);
	/**
		* Always runs the Agenda which has spent less time being interpreted as
		* determined by Stat at each step.
	**/
	static public function par<E>(self:Agenda<E>,that:Agenda<E>):Agenda<E>{
		var lhs : Option<Stat> = None;
		var rhs : Option<Stat> = None;

		function ord(){
			return switch([lhs,rhs]){
				case [Some(l),Some(r)] 	: l.value() < r.value();
				case [None,Some(_)]		 	: true;
				case [Some(_),None]		 	: false;
				default 								: true;
			}
		}
		function nxt(v:Agenda<E>){
			return switch(v){
				case Emit(head,tail) : Some(head);
				default 						 : None;
			}
		}
		function rec(self:Agenda<E>,that:Agenda<E>):Agenda<E>{
			lhs = nxt(self).or(() -> lhs);
			rhs = nxt(that).or(() -> rhs);
			///trace('($lhs) ($rhs)');
			var i 		= ord() ? self : that;
			var u 		= ord() ? that : self;
			var fun 	= __.into(ord() ? rec.bind(_,that) : rec.bind(self));
			return lift(switch(i){
				case Wait(arw) 														: __.wait(arw.mod(fun));//TODO timings here
				case Emit(_,tail)													: tail.mod(fun);
				case Hold(ft)															: __.hold(ft.mod(fun));
				case Halt(Terminated(CauseSum.Exit(err)))	: i.seq(u.escape());
				case Halt(ret)	  												: i.seq(u);
			});
		}
		return rec(self,that);
	}
	static public function seq<E>(self:Agenda<E>,that:Agenda<E>):Agenda<E>{
		return lift(Coroutine._.flat_map_r(
			self,
			(statI) -> Coroutine._.map_r(
				that,
				(statII) -> 
					__.option(statI)
						.flat_map(
							v0 -> __.option(statII)
								.map( v1 -> v0.add(v1))
						).defv(Stat.unit())
			)
		));
	}
	static public function escape<E>(self:Agenda<E>):Agenda<E>{
		return lift(Coroutine._.escape(self));
	}
}