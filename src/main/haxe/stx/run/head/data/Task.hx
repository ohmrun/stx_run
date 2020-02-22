package stx.run.head.data;

interface Task{
  public var state(get,set): TaskState;
  function get_state():TaskState;
  function set_state(ts:TaskState):TaskState;

  public function perform():Void;
  public function release():Void;
}

  //Execute(error:Thunk<Option<Error>>);
  //Release(thunk:Thunk<T>);
  //Command(fn:T->Void,V:T);
  //Receive(rc:Receiver<T>);
  //Conduct<O>(i:T,fn:I->(O->Void)->Void);
  //Perform