package stx.run.head.data;

enum Waiting{
  Ready;

  
  Indefinite;
  Unknown;

  Timed(float:Float);
  
  Later(cb:(Noise->Void)->Void);
}