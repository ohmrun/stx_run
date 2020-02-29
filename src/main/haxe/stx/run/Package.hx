package stx.run;

class Package{
  
}
typedef Reactor<T>        = stx.run.pack.Reactor<T>;

typedef Receiver<O>       = stx.run.pack.Receiver<O>;
typedef Waiter<R,E>       = stx.run.pack.Waiter<R,E>;

typedef Automation        = stx.run.pack.Automation;

typedef Strand<O>         = stx.run.pack.Strand<O>;
typedef Task              = stx.run.pack.Task;

typedef IO<R,E>           = stx.run.pack.IO<R,E>;
typedef UIO<R>            = stx.run.pack.UIO<R>;
typedef EIO<E>            = stx.run.pack.EIO<E>;
typedef Chomp<R,E>        = stx.run.pack.Chomp<R,E>;
typedef Operation<R,E>    = stx.run.pack.Operation<R,E>;
typedef Recall<I,O,R>     = stx.run.pack.Recall<I,O,R>;

typedef Run               = stx.run.pack.Run;
typedef AutomationError   = stx.run.pack.AutomationError;

typedef Limit             = stx.run.type.Limit;
typedef Profile           = stx.run.type.Profile;

typedef Spinner           = stx.run.pack.Spinner;

typedef Bang              = stx.run.pack.Bang;
typedef Queue             = stx.run.pack.Queue;