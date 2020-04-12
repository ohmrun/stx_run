package stx.run.pack;

@:allow(stx) abstract Response<E>(Task) from Task{
	private function new(deferred){
		this = deferred;
	}
	@:noUsing static public function until<E>(task:Task):Response<E>{
		return new Response(Task.lift(task));
	}
	@:noUsing static public function error<E>(e:Err<AutomationFailure<E>>):Response<E>{
		return until(new stx.run.pack.task.term.Error(e));
	}
	public function submit(){
 		this.submit();
	}
}