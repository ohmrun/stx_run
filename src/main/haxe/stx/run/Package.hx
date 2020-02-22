package stx.run;

class Package{
  
}
typedef Observer<T>       = stx.run.pack.Observer<T>;
typedef Receiver<O>       = stx.run.pack.Receiver<O>;
typedef Waiter<R,E>       = stx.run.pack.Waiter<R,E>;

typedef Automation        = stx.run.pack.Automation;


typedef Continue<O>       = stx.run.pack.Continue<O>;
typedef Task              = stx.run.pack.Task;

typedef IO<R,E>           = stx.run.pack.IO<R,E>;
typedef UIO<R>            = stx.run.pack.UIO<R>;
typedef EIO<E>            = stx.run.pack.EIO<E>;
typedef Bang              = stx.run.pack.Bang;

typedef JobQueue          = stx.run.pack.JobQueue;
typedef Thread            = stx.run.pack.Thread;
typedef Deferred          = stx.run.pack.Deferred;


typedef Automations       = stx.run.head.Automations;
typedef IOs               = stx.run.head.IOs;
typedef EIOs              = stx.run.head.EIOs;
typedef Continues         = stx.run.head.Continues;
typedef UIOs              = stx.run.head.UIOs;
typedef Receivers         = stx.run.head.Receivers;

