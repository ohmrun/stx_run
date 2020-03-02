
fn main() {
    println!("Hello, world!");
}
type Handler<O> = fn(o:O);

trait Recaller<I,O,R>{
  fn apply(&self,i:I,cont:Handler<O>) -> R;
}
type Reactor<O> = dyn Recaller<(),O,()>;

//
//fn pure<O>(o:O) -> Reactor<O>{
//  return new({
//    fn apply(i,cont) {
//      cont(o);
//    }
//  })
//}

mod reactor_constructor{
  
}
