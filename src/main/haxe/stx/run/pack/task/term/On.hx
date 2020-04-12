package stx.run.pack.task.term;

class On extends When<Noise>{
  public function new(_on:Bang){
    super();
    _on.stage(
      ()->{},
      ()->this.trigger.trigger(Noise)
    );
  } 
}