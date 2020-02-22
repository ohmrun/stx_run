package stx.run.pack;

import stx.run.head.data.Receiver in ReceiverT;

@:forward @:callable abstract Receiver<O>(ReceiverT<O>) to ReceiverT<O>{
  public function new(self){
    this = self;
  }
  static public function lift<T>(v:ReceiverT<T>):Receiver<T>{
    return new Receiver(v);
  }
  @:noUsing static public function fromObserver<T>(obs:Observer<T>):Receiver<T>{
    return lift((cb:T->Void)->{
      return __.run().task(obs.prj().bind(cb)).toAutomation();
    });
  }
  //TODO, add canceller to automation
  static public function fromFuture<T>(ft:Future<T>) return Receivers.fromFuture(ft);

  public function map<U>(fn:O->U):Receiver<U>{
    return lift(
      (cb:U->Void) -> this((o:O) -> cb(fn(o)))
    );
  }
  public function fmap<U>(fn:O->Receiver<U>):Receiver<U>{
    return lift(
      (cb:U->Void) -> this(
        (o:O) -> fn(o)(cb)
      )
    );
  }
  public function toWaiter():Waiter<O,Noise>{
    return new Waiter((cb:Chunk<O,Noise>->Void) -> this((v) -> cb(Val(v))));
  }

  public function prj():ReceiverT<O>{
    return this;
  }
  public function command(cmd:O->Void):Receiver<O>{
    return map(
      __.command(cmd)
    );
  }
  public function terminal():Observer<Tuple2<O,Automation>>{
    return Observer.lift((next:Tuple2<O,Automation>->Void) -> {
      var data = None;
      var task = None;

      var gate = () -> 
        switch([data,task]){
          case [Some(data),Some(task)] : next(tuple2(data,task));
          default : 
        };
        
      task = Some(this((o) -> {
        data = Some(o);
        /**
          If the task value is populated here, we're asynchronous.
        **/
        gate();
      }));
      /**
        If the data value is populated here, we're synchronous.
      **/
      gate();
    });
  }
}
